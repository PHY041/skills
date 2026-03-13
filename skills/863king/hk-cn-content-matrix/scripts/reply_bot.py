#!/usr/bin/env python3
"""
自动回复脚本 - 智能回复评论和私聊
"""

import random

REPLY_TEMPLATES = {
    "感谢": [
        "谢谢喜欢！🥰",
        "感谢支持~❤️",
        "你喜欢太好了！",
        "谢谢~会继续努力的！"
    ],
    "提问": [
        "可以私信我哦~",
        "具体问题可以评论告诉我~",
        "私聊我吧，给你详细解答！"
    ],
    "引导": [
        "喜欢的话点个赞吧👍",
        "收藏起来慢慢看📚",
        "关注我不迷路~",
        "转发给朋友看看~"
    ]
}

def analyze_sentiment(text):
    """分析评论情感"""
    
    if "喜欢" in text or "好" in text or "赞" in text:
        return "感谢"
    elif "怎么" in text or "哪里" in text or "多少钱" in text:
        return "提问"
    else:
        return "引导"

def auto_reply(comment):
    """生成自动回复"""
    
    sentiment = analyze_sentiment(comment)
    
    if sentiment in REPLY_TEMPLATES:
        return random.choice(REPLY_TEMPLATES[sentiment])
    
    return "谢谢你的评论！"

def main():
    # 模拟评论
    test_comments = [
        "太喜欢了！",
        "怎么买？",
        "好棒的内容！",
        "在哪里？"
    ]
    
    print("=== 自动回复测试 ===")
    for comment in test_comments:
        reply = auto_reply(comment)
        print(f"\n评论: {comment}")
        print(f"回复: {reply}")

if __name__ == '__main__':
    main()
