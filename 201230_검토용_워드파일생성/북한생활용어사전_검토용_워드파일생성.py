import pandas as pd 
import requests 
import csv
from docx import Document

df = pd.read_excel('C:/Users/usder/Desktop/python/201230/북한생활용어사전_목록_검토용 편집_201229.xlsx', sheet_name='201224_북한생활용어',engine="openpyxl")

document = Document() 

for i in range(len(df)):
    if str(df['용법'][i])=="nan":
        yong = "\n"
    else:
        yong = "\n용법 : " + str(df['용법'][i]) +"\n"
    document.add_paragraph(str(df['표제어번호'][i])+"\n"+str(df['표제어'][i])+" "+str(df['형태정보'][i])+" "+str(df['품사'][i])+"\n"+str(df['뜻풀이'][i])+yong+"\n검토 결과:\n추가 의견:")




document.save("테스트.docx")

