#!/usr/bin/env python3
import sys
import json
import subprocess

def send_to_amazonq(message):
    """
    qDeveloperCliを使用してAmazon Qにメッセージを送信
    """
    try:
        # qDeveloperCliを使用してAmazon Qと通信
        # --no-inputフラグでインタラクティブモードを無効化
        cmd = ['q', 'chat', '--no-input', message]
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        
        if result.returncode == 0:
            # 出力から不要なプロンプトやコントロール文字を除去
            output = result.stdout.strip()
            # 最初の行がプロンプトの場合は除去
            lines = output.split('\n')
            if lines and ('>' in lines[0] or 'Q:' in lines[0]):
                lines = lines[1:]
            return '\n'.join(lines).strip()
        else:
            return f"Error: {result.stderr.strip()}"
            
    except subprocess.TimeoutExpired:
        return "Error: Request timed out"
    except FileNotFoundError:
        return "Error: qDeveloperCli not found. Please install qDeveloperCli and configure Amazon Q access."
    except Exception as e:
        return f"Error: {str(e)}"

def main():
    if len(sys.argv) != 2:
        print("Usage: amazonq_client.py <message>")
        sys.exit(1)
    
    message = sys.argv[1]
    response = send_to_amazonq(message)
    print(response)

if __name__ == "__main__":
    main()