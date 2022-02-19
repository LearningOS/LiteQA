import json,time

class Fixjson:
    example_json_1={
        "aid": "ion145n67266uy",
        "result": {"folders": ["通知"],
        "unique_views": 38, "request_instructor_me": 0,
        "change_log": [
            {"data": "iomfqy3rhoe52m", "anon": "no", "when": "2016-05-25T05:33:57Z", "uid": "hcrrjuyequh4bt", "type": "create"}, 
            {"data": "iomgy81af0o7q", "anon": "no", "when": "2016-05-25T06:07:36Z", "uid": "hcrrjuyequh4bt", "type": "update"}],
        "upvote_ids": [],
        "id": "iomfqy3qy2a52l",
        "bookmarked": 4,
        "no_answer_followup": 0,
        "i_edits": [],
        "is_bookmarked": 0,
        "children": [],
        "nr": 899, # json标号
        "bucket_order": 0, 
        "config": {}, "status": "active", 
        "tags": ["instructor-note", "pin", "通知"], 
        "num_favorites": 0, "bucket_name": "Pinned", "q_edits": [], "data": {"embed_links": []}, "request_instructor": 0, 
        "created": "2016-05-25T05:33:57Z",# 时间 
        "is_tag_good": 0, "type": "note", "s_edits": [], 
        "my_favorite": 0, "default_anonymity": "no", "t": 1464190325394, "tag_good": [], "tag_good_arr": [], 
        "history": [{
        "content": "",# 内容
        "anon": "no",
        "subject": "系统方向的国外教授",# 标题
        "uid": "hcrrjuyequh4bt",
        "created": "2016-05-25T05:33:57Z"}]}, "error": 0
        }
    def add(subject,content,tags,nr,bucket_name):
        new_json=Fixjson.example_json_1
        localtime = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.localtime()) 
        new_json['result']['nr']=nr
        new_json['result']['created']=localtime;
        new_json['result']['subject']=subject
        new_json['result']['history']=[{
            "content": content,#内容
            "anon": "no",
            "subject": subject,# 标题
            "uid": "hcrrjuyequh4bt",
            "created": localtime}]
        new_json['result']['tags']=tags
        new_json['result']['bucket_name']=bucket_name
        return new_json

    def run(self,nr,subject,content,tags,bucket_name):
        T=Fixjson.add(subject,content,tags,nr,bucket_name)
        jsdata=json.dumps(T,ensure_ascii=False,indent=4)
        filestr="/piazza-data/"+(str(nr))+".json"
        f=open(filestr,"w",encoding='utf-8')
        f.write(jsdata)
        f.close()



# A=Fixjson()
# A.run(2020,'标题','内容',['pin',''],'Pinned')