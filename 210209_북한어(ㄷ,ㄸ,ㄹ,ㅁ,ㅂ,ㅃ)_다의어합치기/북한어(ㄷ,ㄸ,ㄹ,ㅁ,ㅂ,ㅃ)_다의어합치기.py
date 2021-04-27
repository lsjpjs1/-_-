import pandas as pd 
import requests 
import csv

df = pd.read_excel('북한어(ㄷ,ㄸ,ㄹ,ㅁ,ㅂ,ㅃ).xlsx', sheet_name='Sheet1',engine="openpyxl")
for i in range(len(df)):
    if i >= len(df):
        break
    else:
        if df['glevel'][i]==1:
            df.loc[i,'explan']= '1.'+df['suppos'][i]+df['explan'][i]
            idx = 1
            while df['eid'][i]==df['eid'][i+idx]:
                df.loc[i,'explan']= df['explan'][i] + str(idx+1) + '.' + df['suppos'][i+idx]+df['explan'][i+idx]
                df = df.drop(i+idx)
                idx = idx+1
            df = df.reset_index(drop=True)
            i = i+idx
        elif df['grp3rd'][i]=='①':
            df.loc[i,'explan']= df['grp3rd'][i]+df['suppos'][i]+df['explan'][i]
            idx = 1
            while df['eid'][i]==df['eid'][i+idx]:
                if df['suppos'][i+idx] == '무':
                    if df['grp3rd'][i] == df['grp3rd'][i+idx]:
                        df.loc[i,'explan']= df['explan'][i] + df['grp3rd'][i] + df['suppos'][i]+df['explan'][i+idx]
                    else:
                        df.loc[i,'explan']= df['explan'][i] + df['grp3rd'][i+idx] + df['suppos'][i]+df['explan'][i+idx]
                else:
                    if df['grp3rd'][i] == df['grp3rd'][i+idx]:
                        df.loc[i,'explan']= df['explan'][i] + df['grp3rd'][i] + df['suppos'][i+idx]+df['explan'][i+idx]
                    else:
                        df.loc[i,'explan']= df['explan'][i] + df['grp3rd'][i+idx] + df['suppos'][i+idx]+df['explan'][i+idx]
                df = df.drop(i+idx)
                idx = idx+1
            df = df.reset_index(drop=True)
            i = i+idx
                

df.to_csv('210209북한어(ㄷ,ㄸ,ㄹ,ㅁ,ㅂ,ㅃ).csv',encoding='utf-8-sig')