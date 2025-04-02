# 项目安装

## 从仓库获取

```bash
# 克隆仓库 / 手动下载
git clone https://github.com/CyrusLee1/FileFly
cd FileFly # 进入到项目目录
```

## 虚拟环境安装项目

```bash
python -m venv .venv

# 进入虚拟环境下
.venv\Scripts\activate.bat  # Windows 提示命令符
.venv\Scripts\Activate.ps1  # Windows Powershell
source .venv/bin/activate  # Linux

# 使用 pip 安装
pip install -r requirements.txt
```

## 直接安装项目

```bash
# 使用 pip 安装
pip install -r requirements.txt
# 同时你可以选择以模块的方式调用 pip
python -m pip install -r requirements.txt
```

# 运行项目

+ 一般情况运行项目

```bash
# 运行项目
flask run --debug

# 或者直接调用 app.py
python run.py
```
