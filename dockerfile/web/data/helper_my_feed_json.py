import json,time

class Fixfeed:
    # 输出有几个置顶的
    def count_pinned(feed):
        cnt=0
        for i in feed:
            if('pin' in i and i['pin']==1):
                cnt+=1
            else :
                break
        return cnt

    # 输出新建一个json的id
    def next_nr_json_id(feed):
        cnt=0
        for i in feed:
            if 'nr' in i:
                cnt=max(cnt,i['nr'])
        cnt+=1
        return cnt
    example_feed_1={
        'fol': '通知|','pin': 1,
        'm': 1633497775843,'rq': 0,'id': 'iomfqy3qy2a52l',
        'unique_views': 3133,
        'score': 3133.0,
        'nid': 'i5j09fnsl7k5x0',
        'is_new': True,
        'bucket_name': 'Pinned',# 'bucket_name': 'Week 12/5 - 12/11',
        'bucket_order': 0,
        'folders': ['通知'],
        'nr': 899,# json标号
        'main_version': 11,
        'request_instructor': 0,
        'log': 
        [{'t': '2016-05-25T05:33:57Z', 'u': 'hcrrjuyequh4bt', 'n': 'create'}, 
        {'t': '2016-05-25T05:35:26Z', 'u': 'hcrrjuyequh4bt', 'n': 'update'},
         {'t': '2019-11-15T22:49:22Z', 'u': 'jqshk8dz5kwhy', 'n': 'followup'}, 
          {'t': '2021-10-06T05:22:55Z', 'u': 'kuez1mmc2ahxn', 'n': 'feedback'}],
        'subject': '系统方向的国外教授',#快照的主题
        'no_answer_followup': 1,
        'num_favorites': 2,
        'type': 'note',
        'tags': ['instructor-note', 'pin', '通知'], # 表示的是该快照所包含的标签，是一个数组
        'gd_f': 0,
        'content_snipet': '\n下述系统方向的教授与我们有一定联系&#xff0c;欢迎对系统感兴趣的同学与他们联系&#xff08;读博&#xff0c;实习&#xff0c;交流等&#xff09;\n. Princeton, Kai Li\n. MIT,\xa0Frans Kaash',
        'view_adjust': 0,
        'modified': '2021-10-06T05:22:55Z',# 修改时间
        'gd': 1,
        'updated': '2016-05-25T05:33:57Z',# 更新时间
        'status': 'active'}
    def add(feed,subject,content_snipet,tags,bucket_name):
        new_feed=Fixfeed.example_feed_1
        localtime = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.localtime()) 
        pin=0
        for i in tags:
            if i == 'pin':
                pin += 1 
                break
        if pin == 1:
            new_feed['pin']=1
        else:
            new_feed['pin']=0
        new_feed['nr']=Fixfeed.next_nr_json_id(feed)
        new_feed['modified']=new_feed['updated']=localtime;
        new_feed['subject']=subject
        new_feed['content_snipet']=content_snipet
        new_feed['log']=[{'t':localtime,'u':'hcrrjuyequh4bt','n':'create'}]
        new_feed['tags']=tags
        new_feed['bucket_name']=bucket_name
        return new_feed

    def run(self,name,subject,content_snipet,tags,bucket_name):
        f= open(name, encoding='utf-8')
        res = f.read()
        f.close()

        product_dic = json.loads(res)
        
        print(type(product_dic))
        result=product_dic['result']
        feed=result['feed']
        # print(feed)
        # {'fol': '', 'pin': 1, 'm': 1422588163666, 'rq': 0, 'id': 'i5j09g7m4fs5xk', 'unique_views': 1689, 'score': 1689.0, 'nid': 'i5j09fnsl7k5x0', 'is_new': True, 'bucket_name': 'Pinned', 'bucket_order': 0, 'folders': [], 'nr': 5, 'main_version': 1, 'request_instructor': 0, 'log': [{'t': '2015-01-30T03:22:43Z', 'u': 'gd6v7134AUa', 'n': 'create'}], 'subject': 'Search for Teammates!', 'no_answer_followup': 0, 'num_favorites': 1, 'type': 'note', 'tags': ['pin', 'student'], 'content_snipet': '', 'view_adjust': 0, 'modified': '2015-01-30T03:22:43Z', 'gd': 2, 'updated': '2015-01-30T03:22:43Z', 'status': 'active'}
        
        print(Fixfeed.count_pinned(feed))
        print(Fixfeed.next_nr_json_id(feed))
        T=Fixfeed.add(feed,subject,content_snipet,tags,bucket_name)
        feed.insert(Fixfeed.count_pinned(feed),T)
        result['feed']=feed
        product_dic['result']=result
        print(T)
        
        jsdata=json.dumps(product_dic,encoding="utf-8")
        f=open(name, "w",encoding='utf-8')
        f.write(jsdata)
        f.close()



# A=Fixfeed()
# A.run('piazza_my_feed.json','标题','摘要',['pin',''],'Pinned')