import subprocess
import sys
import argparse
import json

def scan_skill(target_url):
    """
    使用 AgentGuard 扫描指定的外部技能仓库或压缩包。
    由于我们在底层实际调用 npx，所以要求环境里装有 Node.js。
    返回 True 代表安全，False 代表查出红牌。
    """
    print(f"[*] 正在启动 AgentGuard 静默扫描目标: {target_url} ...")
    
    # [SECURITY FIX]: 移除 shell=True，改用安全的列表传参，防止针对 target_url 的命令注入攻击
    command = ["npx", "agentguard", "scan", target_url]
    
    try:
        # 捕获输出进行严格解析
        # 真实环境中 npx agentguard scan <url> 如果有严重警报通常会存在 EXIT_CODE != 0。
        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            check=False
        )
        
        output = result.stdout.lower() + result.stderr.lower()
        
        # 简单判定：如果扫描包含如下等高危词汇或非 0 退出码，认定为红牌
        unsafe_keywords = ["critical", "malicious", "steal", "leak", "high risk", "block"]
        is_unsafe = False
        
        if result.returncode != 0:
            is_unsafe = True
            
        for kw in unsafe_keywords:
            if kw in output:
                is_unsafe = True
                break
                
        if is_unsafe:
            print("[!] 扫描结果：检测到严重安全风险 (UNSAFE)。建议静默丢弃。")
            sys.exit(1) # 抛出非0错误码，供大模型系统识别这是失败的分支
        else:
            print("[+] 扫描结果：未发现高危动作 (SAFE)。可以通过。")
            sys.exit(0)
            
    except Exception as e:
        print(f"[-] 执行扫描时发生未知错误: {str(e)}")
        # 为了绝对安全，发生执行错误也回退为 UNSAFE 打回
        sys.exit(1)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="AgentGuard Security Scanner Script")
    parser.add_argument("target", help="需要扫描的 GitHub URL 或文件路径")
    args = parser.parse_args()
    
    scan_skill(args.target)
