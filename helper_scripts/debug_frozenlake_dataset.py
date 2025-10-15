#!/usr/bin/env python3
"""
Debug script to analyze the frozenlake dataset and check for image validation issues.
This helps identify mismatches between <image> tags and actual images.
"""

import json
import os
from pathlib import Path
from collections import Counter

def count_image_tags(content):
    """Count occurrences of <image> placeholder in content."""
    return content.count("<image>")

def analyze_dataset(json_path, message_key="messages[textual-cot]"):
    """Analyze the dataset for image validation issues."""
    
    print(f"Loading dataset from: {json_path}")
    print(f"Using message key: {message_key}")
    print("=" * 80)
    
    with open(json_path, 'r') as f:
        data = json.load(f)
    
    print(f"Total samples in dataset: {len(data)}")
    print("=" * 80)
    
    # Track statistics
    issues = []
    image_count_distribution = Counter()
    tag_count_distribution = Counter()
    
    for idx, sample in enumerate(data):
        # Get images
        images = sample.get("images", [])
        num_images = len(images)
        
        # Get messages
        messages = sample.get(message_key, [])
        
        # Count <image> tags in all messages
        total_image_tags = 0
        for msg in messages:
            if "content" in msg:
                total_image_tags += count_image_tags(msg["content"])
        
        # Track distributions
        image_count_distribution[num_images] += 1
        tag_count_distribution[total_image_tags] += 1
        
        # Check for mismatches
        if num_images != total_image_tags:
            issues.append({
                "index": idx,
                "num_images": num_images,
                "num_tags": total_image_tags,
                "images": images,
                "messages": messages
            })
    
    # Print analysis results
    print("\n📊 STATISTICS:")
    print(f"  Total samples: {len(data)}")
    print(f"  Samples with issues: {len(issues)}")
    print(f"  Samples without issues: {len(data) - len(issues)}")
    
    print("\n📈 Image count distribution:")
    for count, freq in sorted(image_count_distribution.items()):
        print(f"  {count} images: {freq} samples")
    
    print("\n📈 <image> tag count distribution:")
    for count, freq in sorted(tag_count_distribution.items()):
        print(f"  {count} tags: {freq} samples")
    
    # Show detailed issues
    if issues:
        print("\n⚠️  VALIDATION ISSUES FOUND:")
        print(f"  {len(issues)} samples have mismatched image counts")
        
        # Show first few issues in detail
        for issue in issues[:5]:
            print(f"\n  Sample #{issue['index']}:")
            print(f"    Images provided: {issue['num_images']}")
            print(f"    <image> tags found: {issue['num_tags']}")
            print(f"    Image paths: {issue['images']}")
            
            # Show message contents
            for i, msg in enumerate(issue['messages']):
                role = msg.get('role', 'unknown')
                content = msg.get('content', '')
                tag_count = count_image_tags(content)
                
                # Truncate long content for display
                if len(content) > 200:
                    content_preview = content[:200] + "..."
                else:
                    content_preview = content
                
                print(f"    Message {i} ({role}): {tag_count} <image> tags")
                print(f"      Content preview: {content_preview}")
        
        if len(issues) > 5:
            print(f"\n  ... and {len(issues) - 5} more issues")
    else:
        print("\n✅ NO VALIDATION ISSUES FOUND!")
        print("  All samples have matching image counts")
    
    # Show sample data structure
    print("\n" + "=" * 80)
    print("📝 SAMPLE DATA STRUCTURE (first entry):")
    if data:
        sample = data[0]
        print(f"\nAvailable keys: {list(sample.keys())}")
        print(f"\nImages ({len(sample.get('images', []))}):")
        for img in sample.get("images", [])[:3]:
            print(f"  - {img}")
        
        print(f"\nMessages from '{message_key}':")
        messages = sample.get(message_key, [])
        for i, msg in enumerate(messages[:2]):
            print(f"\n  Message {i}:")
            print(f"    Role: {msg.get('role', 'N/A')}")
            content = msg.get('content', '')
            print(f"    Content length: {len(content)} chars")
            print(f"    <image> tags: {count_image_tags(content)}")
            if len(content) > 300:
                print(f"    Content preview: {content[:300]}...")
            else:
                print(f"    Content: {content}")

def main():
    # Path to the dataset
    dataset_path = "data/data/frozenlake/train/frozenlake_sharegpt.json"
    
    # Check if file exists
    if not os.path.exists(dataset_path):
        print(f"❌ Error: Dataset file not found at {dataset_path}")
        print("Please check the path and try again.")
        return
    
    print("🔍 Debugging Frozenlake Dataset - Image Validation")
    print("=" * 80)
    
    # Analyze different message types
    message_types = [
        "messages[textual-cot]",
        "messages[sft]",
        "messages[visual-cot]",
        "messages[textual-cot-constant]",
        "messages[textual-cot-noisetoken]"
    ]
    
    # Check which message types exist
    with open(dataset_path, 'r') as f:
        sample_data = json.load(f)
        if sample_data:
            available_types = [mt for mt in message_types if mt in sample_data[0]]
            print(f"Available message types in dataset: {available_types}")
    
    # Analyze the textual-cot variant (as specified in the config)
    print("\n" + "=" * 80)
    print("Analyzing 'messages[textual-cot]' variant:")
    print("=" * 80)
    analyze_dataset(dataset_path, "messages[textual-cot]")
    
    # Optionally analyze other variants for comparison
    print("\n" + "=" * 80)
    print("COMPARISON: Analyzing 'messages[sft]' variant:")
    print("=" * 80)
    analyze_dataset(dataset_path, "messages[sft]")

if __name__ == "__main__":
    main()