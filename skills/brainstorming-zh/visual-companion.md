# 视觉伴侣（Visual Companion）使用指南

**用途**: 在头脑风暴期间展示 mockup、图表和视觉选项的浏览器伴侣

**特性**: 作为工具可用 —— 不是模式。接受伴侣意味着它可用于受益于视觉处理的问题；**不**意味着每个问题都通过浏览器。

---

## 提供视觉伴侣

### 时机

当你预见即将到来的问题将涉及视觉内容时：
- mockup（界面原型）
- 布局图
- 架构图
- 并排对比设计

### 提议话术（单独消息）

```
我们正在做的一些内容，如果能在网页浏览器中展示给你可能会更容易解释。我可以随时准备 mockup、图表、对比和其他视觉内容。

这个功能还比较新，token 消耗可能较高。想试试吗？（需要打开本地 URL）
```

### 关键规则

**这个提议必须是单独的消息。**

不要与以下内容合并：
- 澄清问题
- 上下文摘要
- 任何其他内容

消息应该**只**包含上面的提议，别无其他。

等待用户回复再继续。如果他们拒绝，继续纯文本头脑风暴。

---

## 逐问题决策

即使用户接受了伴侣，也要**对每个问题**决定是否使用浏览器或终端。

### 测试标准

**用户通过看到比读到更容易理解吗？**

### 使用浏览器（视觉内容）

- mockup / 线框图
- 布局对比
- 架构图
- 并排视觉设计

### 使用终端（文本内容）

- 需求问题
- 概念选择
- 权衡列表
- A/B/C/D 文本选项
- 范围决策

### 示例

| 问题 | 类型 | 工具 |
|------|------|------|
| "这个上下文中个性是什么意思？" | 概念问题 | 终端 |
| "哪种向导布局更好？" | 视觉问题 | 浏览器 |
| "A/B/C 哪种方案？" | 对比问题 | 浏览器（如果有图）/ 终端（如果纯文本） |

---

## 技术实现

### 启动服务器

```bash
# 进入 scripts 目录
cd skills/brainstorming-zh/scripts

# 启动服务器
./start-server.sh --project-dir ~/my-project

# 输出示例：
{"type":"server-started","port":52341,"url":"http://localhost:52341","screen_dir":"/Users/y/my-project/.superpowers/brainstorm/12345-1699123456"}
```

**关键参数**:
- `--project-dir`: 使用项目目录保存文件（持久化）
- `--foreground`: 前台运行（某些环境必需）
- `--host`: 绑定地址（默认 127.0.0.1）

### 生成视觉内容

创建 HTML 文件到 `screen_dir`:

```bash
SCREEN_DIR="/Users/y/my-project/.superpowers/brainstorm/12345-1699123456"

cat > "$SCREEN_DIR/my-design.html" << 'EOF'
<div class="section">
  <h2>选择界面布局</h2>
  
  <div class="options">
    <div class="option" data-choice="A" onclick="toggleSelect(this)">
      <div class="letter">A</div>
      <div class="content">
        <h3>方案A：左侧导航</h3>
        <p>适合信息密集型应用</p>
      </div>
    </div>
    
    <div class="option" data-choice="B" onclick="toggleSelect(this)">
      <div class="letter">B</div>
      <div class="content">
        <h3>方案B：顶部导航</h3>
        <p>适合内容展示型应用</p>
      </div>
    </div>
  </div>
</div>
EOF
```

### 用户交互流程

1. **AI 给用户 URL**: `http://localhost:52341`
2. **用户打开浏览器**: 查看视觉内容
3. **用户点击选项**: 选择 A 或 B
4. **底部指示栏更新**: "方案A 左侧导航 selected — 返回终端继续"
5. **终端接收事件**: `{"choice":"A",...}`
6. **AI 继续对话**: 基于选择深入讨论

### 停止服务器

```bash
./stop-server.sh /Users/y/my-project/.superpowers/brainstorm/12345-1699123456
```

---

## UI 组件参考

### 选项卡片（单选/多选）

```html
<div class="options" data-multiselect>  <!-- 多选时添加 data-multiselect -->
  <div class="option" data-choice="value1" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>标题</h3>
      <p>描述</p>
    </div>
  </div>
</div>
```

### 图片卡片

```html
<div class="cards">
  <div class="card" data-choice="design1" onclick="toggleSelect(this)">
    <div class="card-image">
      <img src="/files/mockup1.png">
    </div>
    <div class="card-body">
      <h3>设计 1</h3>
      <p>简洁风格</p>
    </div>
  </div>
</div>
```

### Mockup 容器

```html
<div class="mockup">
  <div class="mockup-header">界面标题</div>
  <div class="mockup-body">
    <!-- 界面内容 -->
  </div>
</div>
```

### 左右对比

```html
<div class="split">
  <div><!-- 左侧内容 --></div>
  <div><!-- 右侧内容 --></div>
</div>
```

### 优缺点对比

```html
<div class="pros-cons">
  <div class="pros">
    <h4>优势</h4>
    <ul><li>...</li></ul>
  </div>
  <div class="cons">
    <h4>劣势</h4>
    <ul><li>...</li></ul>
  </div>
</div>
```

---

## 主题与样式

自动适配系统主题：
- **亮色模式**: 浅色背景，深色文字
- **暗色模式**: 深色背景，浅色文字

通过 CSS 变量自动切换，无需额外配置。

---

## 最佳实践

### Do（推荐）

- 每个视觉页面聚焦一个决策点
- 使用清晰、简洁的标签
- 提供对比帮助决策
- 保持视觉层次清晰

### Don't（避免）

- 一个页面塞入过多信息
- 使用专业术语而不解释
- 让用户在 5+ 个选项中选择
- 视觉内容与文本描述不一致

---

## 故障排除

### 浏览器不刷新

1. 检查 WebSocket 连接（DevTools → Network → WS）
2. 验证文件是否正确写入 `screen_dir`
3. 查看 `.events` 文件是否有用户事件记录

### 点击事件未捕获

- 确保元素有 `data-choice` 属性
- 确保有 `onclick="toggleSelect(this)"`
- 检查浏览器控制台是否有 JS 错误

### 服务器启动失败

```bash
# 查看日志
cat /tmp/brainstorm-*/.server.log

# 前台模式排查
./start-server.sh --foreground
```

---

*视觉伴侣指南完成* 🦞⚙️
