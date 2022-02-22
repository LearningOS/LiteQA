# -*- coding: utf-8 -*-
from flask import Flask, request, jsonify
import json
import helper_my_feed_json
import helper_new_json
 
app = Flask(__name__)
app.debug = True
 
 
@app.route('/api/getstatus/',methods=['get'])
def get_status():
    return ('hello,server is runing')
@app.route('/api/test/',methods=['post'])
def test():
    if  not request.data and not request.form:   #检测是否有数据
        return ('fail')
    data = request.data.decode('utf-8')
    print(data)
    data = request.form
    print(data)
    return ('hello world')
@app.route('/api/addnewquestion/',methods=['post'])
def addnewquestion():
    if  not request.form:   #检测是否有数据
        return ('fail')
    data = request.form
    #获取到POST过来的数据。
    print(data)
    
    A=helper_my_feed_json.Fixfeed()
    # A.run('piazza_my_feed.json','标题','摘要',['pin',''],'Pinned')
    nr=A.next_nr_json_id_from_name('./piazza-data-filter/piazza_my_feed.json')
    tags=[]
    bucket_name=''
    if 'pinned' in data:
        tags=['pin','']
        bucket_name='Pinned'
    A.run('./piazza-data-filter/piazza_my_feed.json',data['subject'],data['content_snipet'],tags,bucket_name)
    B=helper_new_json.Fixjson()
    
    B.run(nr,data['subject'],data['content'],tags,bucket_name)
    
    return ('successful')
 
if __name__ == '__main__':
    app.run(host='0.0.0.0',port=1234)