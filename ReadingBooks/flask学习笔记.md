
[toc]
#### 1.2 Hello Flask!
```
pipenv install flask
```


```python
from flask import Flask
app = Flask(__name__)
@app.route('/')
def index():
    return '<h1>Hello Flask!</h1>'
```

- 多个URL
- 动态URL

```
@app.route('/greet', defaults={'name': 'Programmer'})
@app.route('/greet/<name>')    
def greet(name):
    return '<h1>Hello, %s!</h1>' % name

```

#### 1.3 Flask Run

```
pipenv shell
flask run
```

- 自动发现程序实例 app.js 如果重命名 需要修改环境变量

```
export FLASK_APP=hello
```
- 管理环境变量


```
$ pipenv install python-dotenv
```

- .flaskenv用来存储和Flask相关的公开环境变量，比如FLASK_APP
- .env用来存储包含敏感信息的环境变量，比如后面我们会用来配置Email服务器的账户名与密码
- 使用pycharm快速启动flask server


##### 1.3.2 更多的启动选项
1. 使服务器外部可见

```
flask run --host=0.0.0.0
```
2. 改变默认端口
- 执行flask run命令时的host和port选项也可以通过环境变量**FLASK_RUN_HOST**和**FLASK_RUN_PORT**设置。
- 事实上，Flask内置的命令都可以使用这种模式定义默认选项值，即“FLASK_<COMMAND>_<OPTION>”，你可以使用flask--help命令查看所有可用的命令。

1.3.3 设置运行环境

```
FLASK_ENV=development
```
- 调试器
- 重载器

```
pipenv install watchdog --dev
```

