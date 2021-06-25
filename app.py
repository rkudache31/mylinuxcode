from flask import Flask,redirect, url_for, request

app = Flask(__name__)


@app.route("/")
def hello():
    return "Hello World!"
@app.route('/add/<vv>')
def add(vv):
		
	vall=vv
	var=vall.split(',')
	v1=int(var[0])
	v2=int(var[1])
	Addition = v2 + v1
	Val=str(Addition)
	return Val

#app.add_url_rule('/add/<vv>','add',Cal)
@app.route('/login', methods = ['POST', 'GET'])
def login():
		if request.method == 'POST' :
			val1=request.form['v1']
			val2=request.form['v2']
			vm=[]
			vm.append(request.form['v1'])
			vm.append(request.form['v2'])
			return redirect(url_for('Cal',vv=vm))
		else :
			val2=request.args.get('v2')
			val1=request.args.get('v1')
			vm[0]=request.form['v1']
			vm[1]=request.form['v2']
			return redirect(url_for('Cal',vv=vm))
			
	

if __name__ == '__main__':
    app.run(debug=True)
	