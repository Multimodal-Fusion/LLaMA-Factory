import matplotlib.pyplot as plt
import numpy as np

# Data for Direct-SFT and Textual-CoT
samples = [0, 1, 10, 100, 200]  # in thousands (K)
direct_sft = [30.2, 51.4, 57.2, 63.0, 67.4]
textual_cot = [30.2, 60.4, 67.0, 68.8, 75.4]  # Same base, with all data points

# Create the plot
fig, ax = plt.subplots(figsize=(10, 6))

# Plot curves with markers
ax.plot(samples, direct_sft, 'o-', color='#2E86AB', linewidth=2.5, 
        markersize=8, label='Direct-SFT', markeredgecolor='white', markeredgewidth=1.5)
ax.plot(samples, textual_cot, 's-', color='#A23B72', linewidth=2.5, 
        markersize=8, label='Textual-CoT', markeredgecolor='white', markeredgewidth=1.5)

# Add grid
ax.grid(True, alpha=0.3, linestyle='--')

# Labels and title
ax.set_xlabel('Training Samples (K)', fontsize=12, fontweight='bold')
ax.set_ylabel('Test Accuracy (%)', fontsize=12, fontweight='bold')
ax.set_title('FrozenLake-Hard: Direct-SFT vs Textual-CoT Performance\n(Test Set: 500 Problems)', 
             fontsize=14, fontweight='bold', pad=20)

# Set y-axis limits for better visualization
ax.set_ylim(25, 80)

# Add value labels on data points
for i, (x, y) in enumerate(zip(samples, direct_sft)):
    ax.annotate(f'{y:.1f}%', (x, y), textcoords="offset points", 
                xytext=(0,10), ha='center', fontsize=9, color='#2E86AB')

for i, (x, y) in enumerate(zip(samples, textual_cot)):
    ax.annotate(f'{y:.1f}%', (x, y), textcoords="offset points", 
                xytext=(0,-15), ha='center', fontsize=9, color='#A23B72')

# Legend
ax.legend(loc='lower right', frameon=True, fancybox=True, shadow=True, fontsize=11)

# Set x-axis ticks
ax.set_xticks(samples)
ax.set_xticklabels(['Base', '1K', '10K', '100K', '200K'])

# Add performance gain annotation
gain_200k = textual_cot[-1] - direct_sft[-1]
ax.annotate(f'+{gain_200k:.1f}% gain\nwith CoT @ 200K', 
            xy=(200, 71.4), xytext=(150, 73),
            arrowprops=dict(arrowstyle='->', color='gray', alpha=0.7),
            fontsize=10, color='gray', ha='center')

# Adjust layout
plt.tight_layout()

# Save the figure
plt.savefig('frozenlake_performance_comparison.png', dpi=300, bbox_inches='tight')
plt.savefig('frozenlake_performance_comparison.pdf', bbox_inches='tight')

# Show the plot
plt.show()

print("Plot saved as 'frozenlake_performance_comparison.png' and '.pdf'")
print("\nPerformance Summary:")
print("-" * 50)
print("Direct-SFT:")
for i, (s, acc) in enumerate(zip(['Base', '1K', '10K', '100K', '200K'], direct_sft)):
    print(f"  {s:6s}: {acc:.1f}%")
print("\nTextual-CoT:")
for i, (s, acc) in enumerate(zip(['Base', '1K', '10K', '100K', '200K'], textual_cot)):
    print(f"  {s:6s}: {acc:.1f}%")
print("-" * 50)
print(f"\nCoT advantage at 100K samples: +{textual_cot[3] - direct_sft[3]:.1f}%")
print(f"CoT advantage at 200K samples: +{textual_cot[4] - direct_sft[4]:.1f}%")