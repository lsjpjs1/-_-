#!/usr/bin/env python
# coding: utf-8

# In[1]:


import xml.etree.ElementTree as ET
from xml.etree.ElementTree import Element, dump, ElementTree


# In[2]:


import os, glob
 
import os.path

import pandas as pd
df = pd.DataFrame({'파일명':[],'대표표제어': [], '한글표제어': [], '영문표제어': [], '한자표제어': [], '불어표제어':
                   [], '분야': [], '규모': [], '성격': [], '기능': [], '언어': [], '텍스트구조': []
                  , '정보유형': [], '정보범위': [], '규범성': [], '주제': [], '시대': [], '이용자': [], '표제어': []
                   , '표제어표기': [], '분류체계': [], '주표제어와부표제어': [], '원어': [], '발음': [], 
                   '문법정보': [], '전문어': [], '대역어': [], '풀이': [], '용례': [], '관련어': [], '편찬기간': []
                   , '발행년': [], '발행월': [], '발행일': [], '편찬자': [], '번역자': [], '감수자': [], '발행자': [], '출판사': []
                  })

path = "./한중연Xml[1071]/오류파일 수정[1074]"    
    
targerdir = r"./한중연Xml[1071]/오류파일 수정[1074]"
 
files = os.listdir(targerdir)
 
for file in files:
    print(file)
    tree = ET.parse(path+'/'+file)
    root = tree.getroot()
    pushList = list()
    pushList.append(file)
    a=root.find('상위정보').find('자료명').find('대표표제어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('상위정보').find('자료명').find('한글표제어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('상위정보').find('자료명').find('영문표제어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('상위정보').find('자료명').find('한자표제어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('상위정보').find('자료명').find('불어표제어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('상위정보').find('분류정보').find('분야')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('항목기술').find('유형정보').find('규모')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('목적').find('성격')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('목적').find('기능')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('언어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('텍스트구조')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('정보').find('정보유형')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('정보').find('정보범위')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('규범성')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('주제')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('시대')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('유형정보').find('이용자')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('항목기술').find('구조정보').find('거시구조').find('표제어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('거시구조').find('표제어배열')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('거시구조').find('표제어표기')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('거시구조').find('분류체계')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('거시구조').find('주표제어와부표제어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('항목기술').find('구조정보').find('미시구조').find('발음')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('미시구조').find('문법정보')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('미시구조').find('전문어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('미시구조').find('대역어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('미시구조').find('풀이')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('미시구조').find('용례')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('구조정보').find('미시구조').find('관련어')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('항목기술').find('서지역사정보').find('시기').find('편찬기간')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    if root.find('항목기술').find('서지역사정보').find('시기').find('발행년월일'):
        a=root.find('항목기술').find('서지역사정보').find('시기').find('발행년월일').find('발행년')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('발행년월일').find('발행월')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('발행년월일').find('발행일')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
    elif root.find('항목기술').find('서지역사정보').find('시기').find('출판년월일'):
        a=root.find('항목기술').find('서지역사정보').find('시기').find('출판년월일').find('발행년')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('출판년월일').find('발행월')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('출판년월일').find('발행일')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
    elif root.find('항목기술').find('서지역사정보').find('시기').find('편찬년월일'):
        a=root.find('항목기술').find('서지역사정보').find('시기').find('편찬년월일').find('발행년')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('편찬년월일').find('발행월')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('편찬년월일').find('발행일')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
    elif root.find('항목기술').find('서지역사정보').find('시기'):
        a=root.find('항목기술').find('서지역사정보').find('시기').find('발행년')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('발행월')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
        a=root.find('항목기술').find('서지역사정보').find('시기').find('발행일')
        if a != None:
            pushList.append(a.text)
        else:
            pushList.append('')
    

    a=root.find('항목기술').find('서지역사정보').find('참여자').find('편찬자')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('항목기술').find('서지역사정보').find('참여자').find('번역자')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    a=root.find('항목기술').find('서지역사정보').find('참여자').find('감수자')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')

    a=root.find('항목기술').find('서지역사정보').find('참여자').find('발행자')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')


    a=root.find('항목기술').find('서지역사정보').find('기관').find('출판사')
    if a != None:
        pushList.append(a.text)
    else:
        pushList.append('')
    df = df.append(pd.Series(pushList, index=df.columns), ignore_index=True)


# In[158]:





# In[3]:


df.to_csv('오류파일_수정.csv',encoding='utf-8-sig')


# In[92]:





# In[94]:





# In[104]:





# In[109]:





# In[110]:





# In[ ]:




