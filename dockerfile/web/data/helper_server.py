from flask import Flask, request, jsonify
import json
import helper_my_feed_json
import helper_new_json
 
app = Flask(__name__)
app.debug = True
 
 
@app.route('/api/getstatus/',methods=['get'])
def get_status():
    return ('hello,server is runing')
@app.route('/api/addnewquestion/',methods=['post'])
def addnewquestion():
    if  not request.data:   #检测是否有数据
        return ('fail')
    data = request.data.decode('utf-8')
    #获取到POST过来的数据。
    
    
    A=helper_my_feed_json.Fixfeed()
    # A.run('piazza_my_feed.json','标题','摘要',['pin',''],'Pinned')
    nr=A.next_nr_json_id
    A.run('/piazza-data-filter/piazza_my_feed.json',data['subject'],data['content_snipet'],data['tags'],data['bucket_name'])
    B=helper_new_json.Fixjson()
    
    B.run(nr,data['subject'],data['content'],data['tags'],data['bucket_name'])
    
    data_json = json.loads(data)
    #把获取到的数据转为JSON格式。
    return jsonify(data)
    #返回JSON数据。
 
if __name__ == '__main__':
    app.run(host='localhost',port=1234)