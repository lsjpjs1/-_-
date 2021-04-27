#!/usr/bin/env python
# coding: utf-8

# In[5]:


import pandas as pd 
import requests 
import csv
import os
compareDf = pd.read_excel('복사본 명사선별작업(1317).xlsx', sheet_name='Sheet1',engine="openpyxl")
compareDf['민연사전']='미등재'
compareDf['우리말샘']='미등재'
ourDf = pd.read_excel('사전실.xlsx', sheet_name='사전실',engine="openpyxl")
ourDf= ourDf.sort_values('ohw')
ourDf.reset_index(drop=True,inplace=True)
ourDf.rename(columns={'ohw':'어휘'},inplace=True)
compareDf= compareDf.sort_values('명사 등재 후보')
compareDf.reset_index(drop=True,inplace=True)


# In[24]:



targerdir = r"C:\Users\usder\Desktop\python\210414 없는단어찾기\전체 내려받기_우리말샘_xls_20210401"
path='C:/Users/usder/Desktop/python/210414 없는단어찾기/전체 내려받기_우리말샘_xls_20210401/'
samDf = pd.read_excel(path+'830239_100000.xlsx', sheet_name='Sheet0',engine="openpyxl")
files = os.listdir(targerdir)
for idx,i in enumerate(files) :
    print(idx)
    if idx!=0:
        tempPath=path+i
        tempDf = pd.read_excel(tempPath, sheet_name='Sheet0',engine="openpyxl")
        samDf = pd.concat([samDf,tempDf], ignore_index=True)
        


# In[22]:


import pandas as pd 
import requests 
import csv
import os
import sys
sys.setrecursionlimit(10**6)
samDf=pd.read_csv('samDf.csv')
ourDf=pd.read_csv('ourDf.csv')
compareDf=pd.read_csv('compareDf.csv')
new['어휘']=new['어휘'].str.replace(r"-","")
new['어휘']=new['어휘'].str.replace(r"^","")
new=new.sort_values('어휘')
new.reset_index(drop=True,inplace=True)
samDf=new


# In[18]:


def binary_search(df,word, low=None, high=None):
    
    low, high = low or 0, high or len(df) - 1
    if low>=high:
        return False
    mid = (low+high)//2
    if df['어휘'][mid][0]>word[0]:
        return binary_search(df,word,low,mid)
    if df['어휘'][mid][0]==word[0]:
        if df['어휘'][mid]==word:
            return True
        else:
            minVal=min(len(df['어휘'][mid]),len(word))
            for i in range(0,minVal):
                if df['어휘'][mid][i]==word[i]:
                    continue
                else:
                    if df['어휘'][mid][i]>word[i]:
                        return binary_search(df,word,low,mid)
                    else:
                        return binary_search(df,word,mid+1,high)
            if len(df['어휘'][mid])>len(word):
                return binary_search(df,word,low,mid)
            else:
                return binary_search(df,word,mid+1,high)
            
    if df['어휘'][mid][0]<word[0]:
        return binary_search(df,word,mid+1,high)
    


# In[31]:


for i in range(len(compareDf)):
    if binary_search(samDf,compareDf['명사 등재 후보'][i]):
        compareDf['우리말샘'][i]='등재'
    if binary_search(ourDf,compareDf['명사 등재 후보'][i]):
        compareDf['민연사전'][i]='등재'
compareDf.to_csv('result_모든품사.csv',encoding='utf-8-sig')
new=samDf
new['어휘']=new['어휘'].str.replace(r"-","")
new['어휘']=new['어휘'].str.replace(r"^","")
new=new.sort_values('어휘')
new.reset_index(drop=True,inplace=True)
samDf=new
samDf.to_csv('samDfReal.csv',encoding='utf-8-sig')


# In[ ]:





# In[ ]:





# In[ ]:





# In[33]:





# In[28]:





# In[27]:





# In[ ]:





# In[ ]:




