#!/usr/bin/env python
# coding: utf-8

# In[3]:


import pandas as pd 
import requests 
import csv
import os


# In[56]:



basic1Df=pd.read_excel('830142_30000.xlsx', sheet_name='Sheet0',engine="openpyxl")
basic2Df=pd.read_excel('830142_51957.xlsx', sheet_name='Sheet0',engine="openpyxl")


# In[3]:


gonggong=pd.read_excel('공공용어음식+기타_대사전,한한중,기초,한중_지연_도원영.xlsx', sheet_name='공공용어(음식+기타)',engine="openpyxl")
hanyi=pd.read_excel('한의 진료용어 및 서식자료집..xlsx', sheet_name='Sheet1',engine="openpyxl")


# In[57]:


basic1Df.to_csv('basic1Df.csv',encoding='utf-8-sig')
basic2Df.to_csv('basic2Df.csv',encoding='utf-8-sig')
gonggong.to_csv('samDfReal.csv',encoding='utf-8-sig')
hanyi.to_csv('samDfReal.csv',encoding='utf-8-sig')


# In[40]:


sumDf = pd.DataFrame(columns=['headword', 'transword','출처파일','전문어','출처','품사','원어','발음','활용','파생어','관련어','어휘등급'])


# In[18]:


gonggong = gonggong.replace(pd.np.nan, '', regex=True)


# In[41]:


for i in range(1,len(gonggong)):
    tempRow={'headword':'' ,'transword':'','출처파일':'','전문어':'','출처':'','품사':'','원어':'','발음':'','활용':'','파생어':'','관련어':'','어휘등급':''}
    if gonggong['선정 여부 논의 요망'][i]==1 or gonggong['Unnamed: 1'][i]==1:
        tempRow['headword']=gonggong['Unnamed: 3'][i]
        tempRow['transword']=gonggong['Unnamed: 4'][i]
        tempRow['출처']=gonggong['Unnamed: 2'][i]
        tempRow['출처파일']='공공용어'
        sumDf=sumDf.append(tempRow,ignore_index=True)
    
            


# In[45]:


for i in range(1,len(hanyi)):
    tempRow={'headword':'' ,'transword':'','출처파일':'','전문어':'','출처':'','품사':'','원어':'','발음':'','활용':'','파생어':'','관련어':'','어휘등급':''}
    tempRow['headword']=hanyi['한국어'][i]
    tempRow['transword']=hanyi['중국어'][i]
    tempRow['전문어']=hanyi['전문어'][i]
    tempRow['출처']=hanyi['출처'][i]
    tempRow['출처파일']='한의'
    sumDf=sumDf.append(tempRow,ignore_index=True)


# In[61]:


for i in range(len(basic1Df)):
    tempRow={'headword':'' ,'transword':'','출처파일':'','전문어':'','출처':'','품사':'','원어':'','발음':'','활용':'','파생어':'','관련어':'','어휘등급':''}
    tempRow['headword']=basic1Df['표제어'][i]
    tempRow['transword']=basic1Df['중국어 대역어'][i]
    tempRow['품사']=basic1Df['품사'][i]
    tempRow['원어']=basic1Df['원어'][i]
    tempRow['발음']=basic1Df['발음'][i]
    tempRow['활용']=basic1Df['활용'][i]
    tempRow['파생어']=basic1Df['파생어'][i]
    tempRow['관련어']=basic1Df['관련어'][i]
    tempRow['어휘등급']=basic1Df['어휘 등급'][i]
    tempRow['출처파일']='기초사전'
    sumDf=sumDf.append(tempRow,ignore_index=True)


# In[63]:


for i in range(len(basic2Df)):
    tempRow={'headword':'' ,'transword':'','출처파일':'','전문어':'','출처':'','품사':'','원어':'','발음':'','활용':'','파생어':'','관련어':'','어휘등급':''}
    tempRow['headword']=basic2Df['표제어'][i]
    tempRow['transword']=basic2Df['중국어 대역어'][i]
    tempRow['품사']=basic2Df['품사'][i]
    tempRow['원어']=basic2Df['원어'][i]
    tempRow['발음']=basic2Df['발음'][i]
    tempRow['활용']=basic2Df['활용'][i]
    tempRow['파생어']=basic2Df['파생어'][i]
    tempRow['관련어']=basic2Df['관련어'][i]
    tempRow['어휘등급']=basic2Df['어휘 등급'][i]
    tempRow['출처파일']='기초사전'
    sumDf=sumDf.append(tempRow,ignore_index=True)


# In[ ]:


hanhanDf=pd.read_excel('한한중.xlsx')


# In[102]:


for i in range(0,len(hanhanDf)):
    tempRow={'headword':'' ,'transword':'','출처파일':'','전문어':'','출처':'','품사':'','원어':'','발음':'','활용':'','파생어':'','관련어':'','어휘등급':''}
    tempRow['headword']=hanhanDf['searchform'][i]
    tempRow['transword']=hanhanDf['sense_cn'][i]
    tempRow['품사']=hanhanDf['sense_pos'][i]
    tempRow['어휘등급']=hanhanDf['grade'][i]
    tempRow['출처파일']='한한중사전'
    sumDf=sumDf.append(tempRow,ignore_index=True)


# In[104]:


sumDf['headword'] = sumDf['headword'].replace('-', '', regex=True)
sumDf['headword'] = sumDf['headword'].replace(' ', '', regex=True)
sumDf['headword'] = sumDf['headword'].replace('pd.np.nan', '', regex=True)
sumDf['headword']=sumDf['headword'].replace('[^가-힣|^ㄱ-ㅎ|^ㅏ-ㅣ]', '', regex=True)


# In[105]:


sumDf=sumDf.sort_values('headword')
sumDf.reset_index(drop=True,inplace=True)


# In[107]:


sumDf.to_csv('sumDf_전처리완료.csv',encoding='utf-8-sig')


# In[1]:


import pandas as pd 
import requests 
import csv
import os
hanJoongDf=pd.read_excel('한중사전.xlsx')
sumDf=pd.read_csv('sumDf_전처리완료.csv')


# In[8]:


def binary_search(df,word, low, high):
    
    if low>=high:
        return False
    mid = (low+high)//2
    if df['retform'][mid][0]>word[0]:
        return binary_search(df,word,low,mid)
    if df['retform'][mid][0]==word[0]:
        if df['retform'][mid]==word:
            return True
        else:
            minVal=min(len(df['retform'][mid]),len(word))
            for i in range(0,minVal):
                if df['retform'][mid][i]==word[i]:
                    continue
                else:
                    if df['retform'][mid][i]>word[i]:
                        return binary_search(df,word,low,mid)
                    else:
                        return binary_search(df,word,mid+1,high)
            if len(df['retform'][mid])>len(word):
                return binary_search(df,word,low,mid)
            else:
                return binary_search(df,word,mid+1,high)
            
    if df['retform'][mid][0]<word[0]:
        return binary_search(df,word,mid+1,high)
    


# In[13]:


existDf=pd.DataFrame(columns=['headword', 'transword','출처파일','전문어','출처','품사','원어','발음','활용','파생어','관련어','어휘등급'])
notExistDf=pd.DataFrame(columns=['headword', 'transword','출처파일','전문어','출처','품사','원어','발음','활용','파생어','관련어','어휘등급'])


# In[14]:


for i in range(len(sumDf)):
    if i%500==0:
        print(i)
    if binary_search(hanJoongDf,sumDf['headword'][i],0,len(hanJoongDf)):
        existDf=existDf.append(sumDf.loc[i])
    else:
        notExistDf=notExistDf.append(sumDf.loc[i])


# In[17]:


existDf.to_csv('exist.csv',encoding='utf-8-sig')
notExistDf.to_csv('not_exist.csv',encoding='utf-8-sig')


# In[16]:





# In[96]:





# In[69]:





# In[43]:





# In[22]:





# In[18]:





# In[31]:





# In[7]:





# In[8]:





# In[112]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




