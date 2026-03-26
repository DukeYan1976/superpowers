---
# 元数据
doc_type: project-plan
version: 1.0
updated: 2026-03-24
company: {name: "{{COMPANY_NAME}}", short: "{{COMPANY_SHORT}}"}

# ========== 物理工作区规范 (ATF Workspace) ==========
workspace:
  directories:
    plan: 
      path: "01_Project_Plans/"
      desc: "项目级宏观计划"
      naming: "{ProjectName}_ProjectPlan_{YYYYMMDD}_v{X}.{Y}.md"
    iteration:
      path: "02_Iterations/Iteration_{XX}_[{Topic_or_TBD}]/"
      desc: "迭代执行闭环（Topic限15字，未知填TBD）"
      files:
        - { type: "plan", naming: "Iter{XX}_Plan_{YYYYMMDD}_v{X}.{Y}.md", desc: "迭代排期" }
        - { type: "acceptance", naming: "Iter{XX}_Acceptance_{YYYYMMDD}_v{X}.{Y}.md", desc: "TDD测试记录" }
        - { type: "retro", naming: "Iter{XX}_RetroQA_{YYYYMMDD}_v{X}.{Y}.md", desc: "复盘与涌现Q&A" }
    review:
      path: "03_Reviews/"
      desc: "静态审查报告打分"
      naming: "Review_{Target}_{YYYYMMDD}_v{X}.{Y}.md"
    assets:
      path: "04_Assets/"
      desc: "辅助图文资产"

  placement_rules:
    mutation: "【法则1-原地更新】主版本整数，次版本字母(v1.a->v1.b)。必须重命名覆盖旧文件，严禁同目录创建副本！"
    boundary: "【法则2-迭代边界】具体执行、测试用例必须移入 02_Iterations，禁止污染 01 顶层计划！"
    separation: "【法则3-审查分离】静态打分报告进 03_Reviews，动态TDD测试记录进 02_Iterations/Acceptance！"
    qa_spawning: "【法则4-Q&A蓄水池】开发中的架构疑问、模糊需求，必须先记录在 Iteration_XX_RetroQA 中！"

# ========== 规范定义（单一来源）==========
specifications:
  req_id:
    format: "[A-Z]{2}[0-9]+(\\.[0-9]+)?"
    prefix: {AR: "架构", FR: "功能", PR: "性能", MR: "市场", DR: "缺陷", RR: "重构"}
  
  priority:
    levels:
      - {key: "关键", desc: "阻塞项目推进", order: 0}
      - {key: "高", desc: "当前迭代必须完成", order: 1}
      - {key: "中", desc: "有余力时处理", order: 2}
      - {key: "低", desc: "可做可不做", order: 3}
      - {key: "暂缓", desc: "暂停等待时机", order: 4}
  
  estimate:
    methods:
      - name: "人天"
        unit: "人天"
        type: "精确"
        example: "3人天"
      - name: "T恤尺寸法"
        unit: "尺寸"
        type: "相对"
        levels:
          - {size: "XS", range: "<1人天", note: "极简单任务"}
          - {size: "S", range: "1-3人天", note: "小型任务"}
          - {size: "M", range: "3-5人天", note: "中型任务"}
          - {size: "L", range: "5-10人天", note: "大型任务"}
          - {size: "XL", range: ">10人天", note: "需拆分"}

# ========== 章节规范（写作+审查一体化）==========
sections:
  team:
    title: "1 项目组成员"
    required: true
    schema:
      - {field: "project_master", label: "项目负责人", desc: "对整体进度和质量负责"}
      - {field: "product_owner", label: "产品经理", desc: "需求定义与优先级排序"}
      - {field: "developers", label: "开发人员", desc: "技术实现与代码开发"}
      - {field: "qa_engineer", label: "质量工程师", desc: "测试与质量保障"}

  intro:
    title: "2 项目背景介绍"
    required: true
    min_length: 50
    must_contain: ["问题描述", "项目目标", "背景信息"]

  value:
    title: "3 项目价值"
    required: true
    must_contain_metrics: true
    categories: ["财务价值", "技术价值", "战略价值"]

  requirements:
    title: "4 需求列表"
    required: true
    min_items: 1
    columns:
      - {name: "编号", format: "req_id", required: true}
      - {name: "名称", max_length: 15, required: true}
      - {name: "描述", perspective: "客户", required: true}
      - {name: "优先级", enum: "priority", required: true}
      - {name: "预估", type: "estimate", required: true}
    guidelines:
      - "编号格式如AR1, FR2.1"
      - "名称简洁≤15字"
      - "描述从客户视角，而非技术实现"

  plan:
    title: "5 固定合同计划"
    required: false
    when: "固定合同项目"
    columns:
      - {name: "迭代", required: true}
      - {name: "包含需求", required: true, ref: "requirements.编号"}
      - {name: "计划交付", format: "date", required: true}
      - {name: "实际交付", format: "date", required: false}

# ========== AI 指令（统一入口）==========
ai:
  generate:
    role: "{{COMPANY_SHORT}}项目文档助手"
    task: "根据sections规范生成文档内容"
    principles:
      - "严格遵循各章节的schema定义"
      - "必填项(required:true)必须填充"
      - "格式不符合时拒绝生成，提示修改schema"
      - "涉及公司名使用{{COMPANY_NAME}}占位符"
  
  review:
    role: "{{COMPANY_SHORT}}项目文档审查专家"
    task: "根据sections规范审查文档合规性"
    check_list:
      - "所有required:true章节是否有内容"
      - "内容长度是否满足min_length"
      - "是否包含must_contain要求的要素"
      - "表格数据是否符合columns定义的format/enum/type"
      - "预估列需符合人天格式(数字+人天)或T恤尺寸(XS/S/M/L/XL)"
      - "数值型内容是否满足must_contain_metrics"
      - "日期格式是否为YYYY-MM-DD"
      - "公司占位符是否未被意外替换"
    severity:
      error: "违反required/format，必须修改"
      warning: "不满足recommendation，建议优化"
      info: "可改进的空间"
    output: |
      ## 审查报告
      
      ### 结果：[✅通过/⚠️需修改/❌不通过]
      
      ### 问题清单
      |级别|位置|违反规范|具体说明|修改建议|
      |:--:|:---|:-------|:-------|:-------|
      |错误/警告/提示|章节.字段|schema.xxx|实际内容|如何修正|
      
      ### 规范符合度
      |章节|状态|符合率|
      |:---|:---|:---:|
      |项目组成员|✅/❌|100%/x%|
      |...|...|...|
      
      ### 总体评分：X/100

# ========== 更新记录 ==========
changelog:
  - {version: "1.0", date: "2026-03-24", author: "Jarvas", change: "统一写作与审查规范，消除重叠，精简YAML结构"}
---

**更新记录**

| 版本 | 日期 | 作者 | 变更 |
|:---:|:---:|:---:|:---|
| 1.0 | 2026-03-24 | Jarvas | 统一写作与审查规范，消除重叠，正文层级编号 |

---

## 1 项目组成员

| 角色 | 姓名 |
|:---|:---|
| 项目负责人 (Project Master) | |
| 产品经理 (Product Owner) | |
| 开发人员 (Developers) | |
| 质量工程师 (QA Engineer) | |

---

## 2 项目背景介绍

### 2.1 问题陈述
（描述当前存在的问题和痛点）

### 2.2 项目目标
（描述本项目要解决的核心目标）

### 2.3 背景信息
（提供必要的上下文，帮助理解项目重要性）

---

## 3 项目价值

### 3.1 财务价值
（成本节约、收入增加、ROI预估）

### 3.2 技术价值
（性能提升、架构优化、技术债偿还）

### 3.3 战略价值
（市场地位、客户满意度、团队能力建设）

---

## 4 需求列表

**编号规范**：AR=架构, FR=功能, PR=性能, MR=市场, DR=缺陷, RR=重构

| 编号 | 名称 | 描述 | 优先级 | 预估 |
|:---:|:---|:---|:---:|:---:|
| | | | | |
| | | | | |
| | | | | |

### 4.1 需求说明
- **编号**：唯一标识，格式如 AR1, FR2.1, PR3
- **优先级**：关键-阻塞 / 高-必须完成 / 中-有余力时 / 低-可做可不做 / 暂缓-暂停等待
- **预估**：二选一
  - **人天**：精确值，如 3人天、0.5人天
  - **T恤尺寸**：XS(<1人天) / S(1-3人天) / M(3-5人天) / L(5-10人天) / XL(>10人天,需拆分)

---

## 5 固定合同计划

（适用于固定合同项目，按迭代规划交付）

| 迭代 | 包含需求 | 计划交付 | 实际交付 |
|:---:|:---|:---:|:---:|
| 迭代1 | | YYYY-MM-DD | YYYY-MM-DD |
| 迭代2 | | YYYY-MM-DD | YYYY-MM-DD |
| 迭代3 | | YYYY-MM-DD | YYYY-MM-DD |

---

*{{COMPANY_NAME}} ({{COMPANY_SHORT}}) 项目计划文档*
