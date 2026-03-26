# Brainstorming 中文 Skill 文件结构说明

**目录**: `skills/brainstorming-zh/`  
**设计原则**: 外英内中，关键文件中文，技术实现双语注释

---

## 文件清单与语言安排

```
brainstorming-zh/
├── SKILL.md                              # ✅ 中文（主技能文件）
├── README.md                             # ✅ 中文（本说明文件）
├── spec-document-reviewer-prompt.md      # ✅ 中文（子智能体提示词）
├── visual-companion.md                   # ✅ 中文（视觉伴侣指南）
└── scripts/                              # 🔧 技术实现（双语注释）
    ├── start-server.sh                   # 🔧 Bash脚本（中文注释）
    ├── stop-server.sh                    # 🔧 Bash脚本（中文注释）
    ├── server.cjs                        # 🔧 Node.js（中文注释）
    ├── helper.js                         # 🔧 浏览器JS（中文注释）
    └── frame-template.html               # 🎨 UI模板（中文界面）
```

---

## 语言安排理由

### ✅ 必须中文的文件

| 文件 | 理由 |
|------|------|
| **SKILL.md** | AI 读取的主技能文件，决定行为模式 |
| **spec-document-reviewer-prompt.md** | 子智能体 prompt，决定评审输出语言 |
| **visual-companion.md** | 用户使用指南，需中文阅读 |
| **README.md** | 文件结构说明，便于维护 |

### 🔧 技术实现文件（双语注释）

| 文件 | 代码语言 | 注释语言 | 理由 |
|------|---------|---------|------|
| **scripts/*.sh** | Bash | 中文 | 脚本可被 AI 调用，注释帮助理解 |
| **scripts/*.cjs** | JavaScript | 中文 | 核心逻辑，注释便于调试 |
| **scripts/*.js** | JavaScript | 中文 | 浏览器端，注释便于定制 |
| **frame-template.html** | HTML/CSS | 中文 | **UI 文字需中文**，代码保持英文 |

---

## 关键设计决策

### 1. 为什么 scripts/ 不全部翻译？

**原因**：
- 这些文件是**执行文件**，不是**阅读文件**
- AI 调用时是执行命令，不是读取内容学习
- 代码本身是跨平台的（英文关键字）
- 但**注释用中文**，便于开发者维护

### 2. frame-template.html 的特殊处理

**必须中文的部分**：
- 页面标题："Superpowers Brainstorming" → "头脑风暴伴侣"
- 指示栏文字："Click an option above..." → "点击上方选项，然后返回终端"
- 等待页面："Waiting for the agent..." → "等待智能体推送内容..."

**保持英文的部分**：
- CSS 类名（`option`, `mockup`, `card`）
- HTML 结构标签

### 3. spec-document-reviewer-prompt.md 为什么必须中文？

**原因**：
- 这是分派给**子智能体**的 prompt
- 如果 prompt 是英文，子智能体会用英文回复
- 造成中英文混杂，破坏体验

---

## 使用方式

### 在 GEMINI.md 中引用

```markdown
# 中文开发环境配置

## 技能映射

- **头脑风暴**: @./skills/brainstorming-zh/SKILL.md
- **规格评审**: @./skills/brainstorming-zh/spec-document-reviewer-prompt.md
- **视觉伴侣**: @./skills/brainstorming-zh/visual-companion.md

## 系统设置

启动视觉伴侣服务器：
```bash
./skills/brainstorming-zh/scripts/start-server.sh --project-dir .
```
```

### 与原版的关联

```
brainstorming/              # 英文原版（保持不动）
└── ...

brainstorming-zh/           # 中文版本（独立完整）
├── SKILL.md               # 引用中文版本的 scripts/
├── scripts/               # 独立的脚本（中文注释）
└── ...
```

**独立性**：中文版本完全独立，不依赖英文原版的 scripts/

---

## 维护建议

1. **原版更新时**：检查 SKILL.md 的变更，同步更新中文版本
2. **scripts 更新时**：技术逻辑通常通用，重点是更新中文注释
3. **新增文件时**：判断是"阅读文件"还是"执行文件"
   - 阅读文件 → 中文
   - 执行文件 → 双语注释

---

*文件结构说明完成* 🦞⚙️
