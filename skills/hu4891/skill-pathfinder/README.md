<div align="right">
  <strong>English</strong> | <a href="./README_zh-CN.md">简体中文</a>
</div>

# 🌐 Skill-Pathfinder

**A Meta-Skill Engine for AI Agents: Intelligent Routing, Global Discovery, and Silent Security Guard.**

---

## 🎯 What is Skill-Pathfinder?

When your AI Agent (like OpenClaw) faces missing capabilities or complex workflows, **Skill-Pathfinder** acts as its central nervous system. Instead of generating "hallucinated" answers, it strictly enforces a **"Skill First"** principle: 
It automatically breaks down complex intents, searches your local ecosystem for missing tools, downloads new skills from global repositories (ClawHub, MCP Market, etc.), and silently scans them for security risks before asking for your permission to install.

### 📡 Runtime & Permissions (Security Declaration)
To orchestrate tools dynamically and perform global searches, this skill explicitly declares the following requirements:
- **Runtime Required**: `Node.js` (`npm`/`npx`) and `Python 3` must be installed.
- **Filesystem Access**: Read access to `~/.agents/skills` to evaluate the current baseline.
- **Network Access**: Internet access to hub APIs (ClawHub, MCP, etc.) for skill discovery.
- *Note on Security*: Before downloading and recommending any external code, this skill enforces a strict local security scan using `npx agentguard scan` via a secured python wrapper.

---

## ✨ Key Features

1. **🧭 Intelligent Routing**
   It parses ambiguous language into a structured pipeline (e.g., `[Search Web] -> [Analyze Data] -> [Send Email]`) instead of doing everything in a single fragile prompt.

2. **🔍 Active Diagnostics**
   Automatically scans your `.agents/skills` directory and recommends essential starting kits (Web Browsing, File Operating, Calendar) if you are a new user.

3. **🌍 Global Discovery**
   Directly connects to major hubs (ClawHub, MCP Market, Smithery, Glama) to fetch whatever capability you lack.

4. **🛡️ Silent Security Guard**
   Integrates seamlessly with **AgentGuard**. Before recommending any external code, it runs a deep static scan (`security_check.py`). If it detects malicious intents like stealing keys, it drops the skill silently without bothering you.

5. **💬 Language Mirroring**
   No hardcoded UX texts. The status updates and safety prompts will automatically mirror the exact language you used in your initial prompt.

---

## 🚀 Installation

1. **Download the Package:** Download the `Skill-Pathfinder.skill` archive from the Releases page.
2. **Mount to your Agent:** Copy the folder directly into your global agent directory (e.g., `C:\Users\YourName\.agents\skills\Skill-Pathfinder`).
3. **Restart your AI Client:** (e.g., OpenClaw). The router will automatically hijack unhandled complex tasks!

---

## 🛠️ For Developers / Prompts Modification
If you wish to modify its behavior, you can directly edit:
- `SKILL.md`: The main entry and triggering boundary (what NOT to intercept).
- `references/routing.md`: Execution rules.
- `references/discovery.md`: External repo search priorities and AgentGuard strict hooks.

> **License:** Standard MIT License.
