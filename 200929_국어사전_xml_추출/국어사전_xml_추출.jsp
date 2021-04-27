<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/kordic/baseLib.jsp" %>
<%@ page import="java.util.arrayList.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.*"%>
	
<%!
public boolean compareAttrName(String data){
String attrName[] = {"eid","ohw","onum","suppos","freq"};
	for(int i=0;i<attrName.length;i++){
		if(attrName[i].equals(data))
			return true;
	}	
	return false;
}	
%>	
	
<%
	/************************************************
	* PrintWriter 선언
	************************************************/
	PrintWriter writer = response.getWriter();
	
	
	
	
	/************************************************
	* File IO 정의
	************************************************/
	String fileDir = "kordic/"; //파일을 생성할 디렉토리
  	String filePath = request.getRealPath(fileDir) + "/"; //파일을 생성할 전체경로
  	String writeFile = "extract_kor_XML.xml"; //쓸 파일명
  	
  	writeFile = filePath+writeFile; //생성할 파일명을 전체경로에 결합
  	
  	
  	
	BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(
						new FileOutputStream(writeFile), "utf-8"));
	
	
	/************************************************
	* DB 처리용 변수들 선언 및 초기화
	************************************************/
	boolean msg = true; // Message Popup!
	StringBuffer chk = new StringBuffer();
	
	Date d = new Date(); 
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
	String workTime = df.format(d);

	
	/************************************************
	* SQL 처리용 변수들
	************************************************/
	Connection conn = null;
	PreparedStatement statement = null;
	ResultSet rs = null;
	ResultSet rs2 = null;
	ResultSet senseRs = null;
	ResultSet senseRs2 = null;
	ResultSet rtermRs = null;
	ResultSet idiomRs = null;
	ResultSet proverbRs = null;
	ResultSet rtermOhw = null;
	String query = null;
	String pos = null;
	boolean check = false; //entry
	boolean check2 = false; //definition
	boolean check3 = false; //rterm
	boolean check4 = false; //idiom
	boolean check5 = false; //proverb
	int chksenses = 0;
	int chkposandsenses = 0;

	ArrayList<String> tableName=new ArrayList<String>();
	ArrayList<String> fieldName=new ArrayList<String>();
	ArrayList<String> checked = new ArrayList<String>();
	ArrayList<String> checked2 = new ArrayList<String>();
	ArrayList<String> checked3 = new ArrayList<String>();
	ArrayList<String> checked4 = new ArrayList<String>();
	ArrayList<String> checked5 = new ArrayList<String>();
	
	String line = ""; 
	
	//xml로 뽑아낼 table명 등록
	
	tableName.add("kor_extract_new6");
	
	
	try {
		Class.forName(MySqlDriver);
		conn = DriverManager.getConnection(dbUrl, dbId, dbPwd);
		
		for(int i=0;i<tableName.size();i++){
			bw.newLine();
			
			query = "DESCRIBE "+tableName.get(i)+";";
			statement = conn.prepareStatement(query);
			rs=statement.executeQuery();
			while(rs.next()){
				fieldName.add(rs.getString("Field"));
				//writer.print(rs.getString("Field")+"</br>");
			}
			query = "select * from " + tableName.get(i) + " where eid >= 380000 and eid < 455057";
			statement = conn.prepareStatement(query);
			//rs.clear();
			rs2=statement.executeQuery();
			while(rs2.next()){
				for(int j = 0; j<checked.size();j++){ //이미 추출한 eid 인지 검사
					if(rs2.getString("eid").equals(checked.get(j))){
						check = true;
						break;
					}else check = false;
				}
				//start entry
				//HEAD
				if(check == false){
					line += "<ENTRY>\r\n";
					line += "	<HEAD>";
					line += "\r\n";
					line += "	";
					line += "	<EID>";
					line += rs2.getString("eid");
					line += "</EID>\r\n";
					line += "		<HEADWORD SUP=";
					line += '"' + rs2.getString("onum") + '"';
					line += " FRQ=";
					line += '"' + rs2.getString("freq") + '"';
					line += ">"+ rs2.getString("ohw") + "</HEADWORD>\r\n";
					if(!(rs2.getString("morph") == null) &&!rs2.getString("morph").equals("")){
						line += "		<MORPHOLOGY>";
						line += rs2.getString("morph");
						line += "</MORPHOLOGY>\r\n";
					}
					if(!(rs2.getString("pronun") == null) &&!rs2.getString("pronun").equals("")){
						line += "		<PRONUNCIATION>";
						line += rs2.getString("pronun");
						line += "</PRONUNCIATION>\r\n";
					}

					if((!(rs2.getString("conform") == null) && !rs2.getString("conform").equals("")) || (!(rs2.getString("contype") == null) && !rs2.getString("contype").equals(""))){
						if(!(rs2.getString("contype") == null) && !rs2.getString("contype").equals("")){
							line += "		<CONJUGATION TYPE=";
							line += '"' + rs2.getString("contype") + '"';
							if(!(rs2.getString("conform") == null) && !rs2.getString("conform").equals("")){
								line += ">"+ rs2.getString("conform") + "</CONJUGATION>\r\n";
							}
						}
						else {
						line += "		<CONJUGATION>";
						if(!(rs2.getString("conform") == null) && !rs2.getString("conform").equals("")){
							line += rs2.getString("conform");
							line += "</CONJUGATION>\r\n";
							}
						}
					}

					if(!(rs2.getString("etymol") == null) &&!rs2.getString("etymol").equals("")){
						line += "		<ETYMOLOGY>";
						line += rs2.getString("etymol");
						line += "</ETYMOLOGY>\r\n";
					}
					line += "	</HEAD>\r\n";
					
					//END HEAD

					query = "select * from " + tableName.get(i) + " where eid = " + rs2.getString("eid") + " order by eid asc, explan_onum asc"; 
					checked.add(rs2.getString("eid")); //검사한 eid를 추가
					statement = conn.prepareStatement(query);
					senseRs = statement.executeQuery();

					checked2.clear();
					check2 = false;
					String beforePOS = "";// 새로운 eid 일 때 초기화
					
					//START DEFINITIONS
					
					while(senseRs.next()){
						for(int k = 0; k<checked2.size();k++){ //이미 추출한 sense 인지 검사
							if(senseRs.getString("explan_uid").equals(checked2.get(k))){
								check2 = true;
								break;
							}else check2 = false;
						}
						if(check2 == false){
							checked2.add(senseRs.getString("explan_uid"));//검사한 uid 추가
							String g1 = senseRs.getString("grp1st");
							String g2 = senseRs.getString("grp2nd");

							if(beforePOS.equals("history")){
								//품사가 한종류인 표제어를 검사중일 때 -> senseRs.next() 가 null 일 때 까지 sense만 추가
								line += "		<DEFINITION>\r\n"; //ADD DEFINITION
								
								if(!(senseRs.getString("grp1st") == null) && !senseRs.getString("grp1st").equals("")){
									line += "			<CLASS_1ST>";
									line += senseRs.getString("grp1st");
									line += "</CLASS_1ST>\r\n";
								}
								if(!(senseRs.getString("grp2nd") == null) && !senseRs.getString("grp2nd").equals("")){
									line += "			<CLASS_2ND>";
									line += senseRs.getString("grp2nd");
									line += "</CLASS_2ND>\r\n";
								}
								if(!(senseRs.getString("grp3rd") == null) && !senseRs.getString("grp3rd").equals("")){
									line += "			<CLASS_3RD>";
									line += senseRs.getString("grp3rd");
									line += "</CLASS_3RD>\r\n";
								}
								if(!(senseRs.getString("grp4th") == null) && !senseRs.getString("grp4th").equals("")){
									line += "			<CLASS_4TH>";
									line += senseRs.getString("grp4th");
									line += "</CLASS_4TH>\r\n";
								}

								if(!(senseRs.getString("pattern") == null) && !senseRs.getString("pattern").equals("")){
									line += "			<PAT_INFO>";
									line += senseRs.getString("pattern"); //pattern
									line += "</PAT_INFO>\r\n";
								}
								if(!(senseRs.getString("restric") == null) && !senseRs.getString("restric").equals("")){
									line += "			<RES_INFO>";
									line += senseRs.getString("restric") + " ";//restric
									line += "</RES_INFO>\r\n";
								}
								if(!(senseRs.getString("semantic") == null) && !senseRs.getString("semantic").equals("")){
									line += "			<SEM_INFO>";
									line += senseRs.getString("semantic") + " "; //semantic
									line += "</SEM_INFO>\r\n";
								}
								if(!(senseRs.getString("theta") == null) && !senseRs.getString("theta").equals("")){
									line += "			<THE_INFO>";
									line += senseRs.getString("theta") + " "; //theta
									line += "</THE_INFO>\r\n";
								}
								if(!(senseRs.getString("explan_explan") == null) && !senseRs.getString("explan_explan").equals("")){
									line += "			<SENSE>";
									line += senseRs.getString("explan_explan"); //explan_explan
									line += "</SENSE>\r\n";
								}

								/*if(!(senseRs.getString("useform") == null) && !senseRs.getString("useform").equals("")){
									line += "					<USEFORM>";
									line += senseRs.getString("useform");
									line += "</USEFORM>\r\n";
								}*/

								if(!(senseRs.getString("example") == null) && !senseRs.getString("example").equals("")){
									line += "			<EXAMPLE>";
									line += senseRs.getString("example");
									line += "</EXAMPLE>\r\n";
								}

								if(!(senseRs.getString("stype") == null) && !senseRs.getString("stype").equals("")){ //rterm 이 있는 경우만
									line += "			<RTERMS>\r\n";
									//rterm들 모두 뽑기(senseRs 에서)
									query = "select stype, reid, ronum, stdword from " + tableName.get(i) + " where eid =" + senseRs.getString("eid") +" and explan_onum = " +senseRs.getString("explan_onum");
									statement = conn.prepareStatement(query);
									rtermRs = statement.executeQuery();
									checked3.clear();
									check3 = false;
									while(rtermRs.next()){
										for(int m = 0; m<checked3.size();m++){ //이미 추출한 rterm 인지 검사
											String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
											if(a.equals(checked3.get(m))){
												check3 = true;
												break;
											}else check3 = false;
										}
										if(check3 == false){
												query = "select ohw, onum, origin, glevel, grp1st, grp2nd, grp3rd, grp4th from " + tableName.get(i) + " where eid = " + rtermRs.getString("reid") + " and explan_onum = " + rtermRs.getString("ronum"); //관련어의 ohw 뽑기
												statement = conn.prepareStatement(query);
												rtermOhw = statement.executeQuery();
												if(rtermOhw.next()){
													String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
													checked3.add(a);
													line += "				<RTERM EID=" + '"' + rtermRs.getString("reid") + '"';
													line += " TYPE=" + '"' + rtermRs.getString("stype") + '"';
													line += " SUP=" + '"' + rtermOhw.getString("onum") + '"';
													line += " ORG=" + '"' + rtermOhw.getString("origin") + '"';
													line += " SUB=" + '"' + rtermOhw.getString("grp1st") + rtermOhw.getString("grp2nd") + rtermOhw.getString("grp3rd") + rtermOhw.getString("grp4th") + '"';
													line += ">" + rtermOhw.getString("ohw") + "</RTERM>\r\n";
												}
											}
									}
									line += "			</RTERMS>\r\n";
								}
								line += "		</DEFINITION>\r\n";
							}
							else if(beforePOS.equals("")){//새로운 표제어가 들어옴
								if((g1+g2).equals("") || (g1+g2) == null){ //히스토리 지정
									beforePOS = "history";
								} else beforePOS = g1+g2;

								/*line += "	<POSES>";
								if(!(senseRs.getString("suppos") == null) && !senseRs.getString("suppos").equals("")){
									line += "\r\n 		<POS NAME=";
									pos = senseRs.getString("suppos");
									if(pos.equals("ꃃ")) pos = "명사";
									else if(pos.equals("ꂽ")) pos = "대명사";
									else if(pos.equals("ꃓ")) pos = "수사";
									else if(pos.equals("ꂿ")) pos = "동사";
									else if(pos.equals("ꃰ")) pos = "형용사";
									else if(pos.equals("ꂴ")) pos = "관형사";
									else if(pos.equals("ꃌ")) pos = "부사";
									else if(pos.equals("ꂳ")) pos = "감탄사";
									else if(pos.equals("무")) pos = "무품사";
									else if(pos.equals("ꃦ")) pos = "조사";
									else if(pos.equals("ꃥ")) pos = "접사";
									else if(pos.equals("ꃁ")) pos = "어미";
									else if(pos.equals("준")) pos = "준말";
									line += '"' + pos + '"'; //suppos
								}
								if(!(senseRs.getString("subpos") == null) && !senseRs.getString("subpos").equals("")){ //suppos랑 subpos에 둘 다 있을때만
										line += ", ";
										line += '"' + senseRs.getString("subpos") + '"'; //subpos
								}
								line += ">";*/
								line += "	<DEFINITIONS>";
								line += "\r\n		<DEFINITION>\r\n";
								if(!(senseRs.getString("suppos") == null) && !senseRs.getString("suppos").equals("")){
									line += "			<SUPPOS LOCATION=";
									//if()//front-back 추가하기
									line += ">";
									line += senseRs.getString("suppos");
									line += "</SUPPOS>\r\n";
								}

								if(!(senseRs.getString("subpos") == null) && !senseRs.getString("subpos").equals("")){
									line += "			<SUBPOS LOCATION=";
									//if()//front-back 추가하기
									line += ">";
									line += senseRs.getString("subpos");
									line += "</SUBPOS>\r\n";
								}
								
								if(!(senseRs.getString("technic") == null) && !senseRs.getString("technic").equals("")){
									line += "			<TECH_INFO LOCATION=";
									//if()//front-back 추가하기
									line += ">";
									line += senseRs.getString("technic");
									line += "</TECH_INFO>\r\n";
								}
								else if(!(senseRs.getString("explan_technic") == null) && !senseRs.getString("explan_technic").equals("")){
									line += "			<TECH_INFO LOCATION=";
									//if()//front-back 추가하기
									line += ">";
									line += senseRs.getString("explan_technic");
									line += "</TECH_INFO>\r\n";
								}
								
								//ADD DEFINITION

								if(!(senseRs.getString("grp1st") == null) && !senseRs.getString("grp1st").equals("")){
									line += "			<CLASS_1ST>";
									line += senseRs.getString("grp1st");
									line += "</CLASS_1ST>\r\n";
								}
								if(!(senseRs.getString("grp2nd") == null) && !senseRs.getString("grp2nd").equals("")){
									line += "			<CLASS_2ND>";
									line += senseRs.getString("grp2nd");
									line += "</CLASS_2ND>\r\n";
								}
								if(!(senseRs.getString("grp3rd") == null) && !senseRs.getString("grp3rd").equals("")){
									line += "			<CLASS_3RD>";
									line += senseRs.getString("grp3rd");
									line += "</CLASS_3RD>\r\n";
								}
								if(!(senseRs.getString("grp4th") == null) && !senseRs.getString("grp4th").equals("")){
									line += "			<CLASS_4TH>";
									line += senseRs.getString("grp4th");
									line += "</CLASS_4TH>\r\n";
								}

								if(!(senseRs.getString("pattern") == null) && !senseRs.getString("pattern").equals("")){
									line += "			<PAT_INFO>";
									line += senseRs.getString("pattern"); //pattern
									line += "</PAT_INFO>\r\n";
								}
								if(!(senseRs.getString("restric") == null) && !senseRs.getString("restric").equals("")){
									line += "			<RES_INFO>";
									line += senseRs.getString("restric") + " ";//restric
									line += "</RES_INFO>\r\n";
								}
								if(!(senseRs.getString("semantic") == null) && !senseRs.getString("semantic").equals("")){
									line += "			<SEM_INFO>";
									line += senseRs.getString("semantic") + " "; //semantic
									line += "</SEM_INFO>\r\n";
								}
								if(!(senseRs.getString("theta") == null) && !senseRs.getString("theta").equals("")){
									line += "			<THE_INFO>";
									line += senseRs.getString("theta") + " "; //theta
									line += "</THE_INFO>\r\n";
								}
								if(!(senseRs.getString("explan_explan") == null) && !senseRs.getString("explan_explan").equals("")){
									line += "			<SENSE>";
									line += senseRs.getString("explan_explan"); //explan_explan
									line += "</SENSE>\r\n";
								}

								/*if(!(senseRs.getString("useform") == null) && !senseRs.getString("useform").equals("")){
									line += "					<USEFORM>";
									line += senseRs.getString("useform");
									line += "</USEFORM>\r\n";
								}*/

								if(!(senseRs.getString("example") == null) && !senseRs.getString("example").equals("")){
									line += "			<EXAMPLE>";
									line += senseRs.getString("example");
									line += "</EXAMPLE>\r\n";
								}

								if(!(senseRs.getString("stype") == null) && !senseRs.getString("stype").equals("")){ //rterm 이 있는 경우만
									line += "			<RTERMS>\r\n";
									//rterm들 모두 뽑기(senseRs 에서)
									query = "select stype, reid, ronum, stdword from " + tableName.get(i) + " where eid =" + senseRs.getString("eid") +" and explan_onum = " +senseRs.getString("explan_onum");
									statement = conn.prepareStatement(query);
									rtermRs = statement.executeQuery();
									checked3.clear();
									check3 = false;
									while(rtermRs.next()){
										for(int m = 0; m<checked3.size();m++){ //이미 추출한 rterm 인지 검사
											String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
											if(a.equals(checked3.get(m))){
												check3 = true;
												break;
											}else check3 = false;
										}
										if(check3 == false){
												query = "select ohw, onum, origin, glevel, grp1st, grp2nd, grp3rd, grp4th from " + tableName.get(i) + " where eid = " + rtermRs.getString("reid") + " and explan_onum = " + rtermRs.getString("ronum"); //관련어의 ohw 뽑기
												statement = conn.prepareStatement(query);
												rtermOhw = statement.executeQuery();
												if(rtermOhw.next()){
													String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
													checked3.add(a);
													line += "				<RTERM EID=" + '"' + rtermRs.getString("reid") + '"';
													line += " TYPE=" + '"' + rtermRs.getString("stype") + '"';
													line += " SUP=" + '"' + rtermOhw.getString("onum") + '"';
													line += " ORG=" + '"' + rtermOhw.getString("origin") + '"';
													line += " SUB=" + '"' + rtermOhw.getString("grp1st") + rtermOhw.getString("grp2nd") + rtermOhw.getString("grp3rd") + rtermOhw.getString("grp4th") +'"';
													line += ">" + rtermOhw.getString("ohw") + "</RTERM>\r\n";
												}
											}
									}
									line += "			</RTERMS>\r\n";
								}
								line += "		</DEFINITION>\r\n";
							}
							else {//품사가 여러 종류인 표제어를 검사중일 때
								if((g1+g2).equals("")||(g1+g2) == null){ // 계속 추가해서 씀
									line += "		<DEFINITION>\r\n"; //ADD DEFINITION
								
									if(!(senseRs.getString("grp1st") == null) && !senseRs.getString("grp1st").equals("")){
										line += "			<CLASS_1ST>";
										line += senseRs.getString("grp1st");
										line += "</CLASS_1ST>\r\n";
									}
									if(!(senseRs.getString("grp2nd") == null) && !senseRs.getString("grp2nd").equals("")){
										line += "			<CLASS_2ND>";
										line += senseRs.getString("grp2nd");
										line += "</CLASS_2ND>\r\n";
									}
									if(!(senseRs.getString("grp3rd") == null) && !senseRs.getString("grp3rd").equals("")){
										line += "			<CLASS_3RD>";
										line += senseRs.getString("grp3rd");
										line += "</CLASS_3RD>\r\n";
									}
									if(!(senseRs.getString("grp4th") == null) && !senseRs.getString("grp4th").equals("")){
										line += "			<CLASS_4TH>";
										line += senseRs.getString("grp4th");
										line += "</CLASS_4TH>\r\n";
									}
	
									if(!(senseRs.getString("pattern") == null) && !senseRs.getString("pattern").equals("")){
										line += "			<PAT_INFO>";
										line += senseRs.getString("pattern"); //pattern
										line += "</PAT_INFO>\r\n";
									}
									if(!(senseRs.getString("restric") == null) && !senseRs.getString("restric").equals("")){
										line += "			<RES_INFO>";
										line += senseRs.getString("restric") + " ";//restric
										line += "</RES_INFO>\r\n";
									}
									if(!(senseRs.getString("semantic") == null) && !senseRs.getString("semantic").equals("")){
										line += "			<SEM_INFO>";
										line += senseRs.getString("semantic") + " "; //semantic
										line += "</SEM_INFO>\r\n";
									}
									if(!(senseRs.getString("theta") == null) && !senseRs.getString("theta").equals("")){
										line += "			<THE_INFO>";
										line += senseRs.getString("theta") + " "; //theta
										line += "</THE_INFO>\r\n";
									}
									if(!(senseRs.getString("explan_explan") == null) && !senseRs.getString("explan_explan").equals("")){
										line += "			<SENSE>";
										line += senseRs.getString("explan_explan"); //explan_explan
										line += "</SENSE>\r\n";
									}
	
									/*if(!(senseRs.getString("useform") == null) && !senseRs.getString("useform").equals("")){
										line += "					<USEFORM>";
										line += senseRs.getString("useform");
										line += "</USEFORM>\r\n";
									}*/
	
									if(!(senseRs.getString("example") == null) && !senseRs.getString("example").equals("")){
										line += "			<EXAMPLE>";
										line += senseRs.getString("example");
										line += "</EXAMPLE>\r\n";
									}
	
									if(!(senseRs.getString("stype") == null) && !senseRs.getString("stype").equals("")){ //rterm 이 있는 경우만
										line += "			<RTERMS>\r\n";
										//rterm들 모두 뽑기(senseRs 에서)
										query = "select stype, reid, ronum, stdword from " + tableName.get(i) + " where eid =" + senseRs.getString("eid") +" and explan_onum = " +senseRs.getString("explan_onum");
										statement = conn.prepareStatement(query);
										rtermRs = statement.executeQuery();
										checked3.clear();
										check3 = false;
										while(rtermRs.next()){
											for(int m = 0; m<checked3.size();m++){ //이미 추출한 rterm 인지 검사
												String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
												if(a.equals(checked3.get(m))){
													check3 = true;
													break;
												}else check3 = false;
											}
											if(check3 == false){
													query = "select ohw, onum, origin, glevel, grp1st, grp2nd, grp3rd, grp4th from " + tableName.get(i) + " where eid = " + rtermRs.getString("reid") + " and explan_onum = " + rtermRs.getString("ronum"); //관련어의 ohw 뽑기
													statement = conn.prepareStatement(query);
													rtermOhw = statement.executeQuery();
													if(rtermOhw.next()){
														String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
														checked3.add(a);
														line += "				<RTERM EID=" + '"' + rtermRs.getString("reid") + '"';
														line += " TYPE=" + '"' + rtermRs.getString("stype") + '"';
														line += " SUP=" + '"' + rtermOhw.getString("onum") + '"';
														line += " ORG=" + '"' + rtermOhw.getString("origin") + '"';
														line += " SUB=" + '"' + rtermOhw.getString("grp1st") + rtermOhw.getString("grp2nd") + rtermOhw.getString("grp3rd") + rtermOhw.getString("grp4th") +'"';
														line += ">" + rtermOhw.getString("ohw") + "</RTERM>\r\n";
													}
												}
										}
										line += "			</RTERMS>\r\n";
									}
									line += "		</DEFINITION>\r\n";
								}
								else {//새로 pos 생성 후 새로운 히스토리
									/*line += "	<DEFINITIONS>\r\n";
									
									line += "		</DEFINITION>\r\n";*/  //원본@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 20.08.19 수정 아랫 줄은 수정한 내용
									line += "		<DEFINITION>\r\n"; // 이게 수정한거
									
									beforePOS = g1+g2;
									
									/*if(!(senseRs.getString("suppos") == null) && !senseRs.getString("suppos").equals("")){
									line += "\r\n 		<POS NAME=";
									pos = senseRs.getString("suppos");
									if(pos.equals("ꃃ")) pos = "명사";
									else if(pos.equals("ꂽ")) pos = "대명사";
									else if(pos.equals("ꃓ")) pos = "수사";
									else if(pos.equals("ꂿ")) pos = "동사";
									else if(pos.equals("ꃰ")) pos = "형용사";
									else if(pos.equals("ꂴ")) pos = "관형사";
									else if(pos.equals("ꃌ")) pos = "부사";
									else if(pos.equals("ꂳ")) pos = "감탄사";
									else if(pos.equals("무")) pos = "무품사";
									else if(pos.equals("ꃦ")) pos = "조사";
									else if(pos.equals("ꃥ")) pos = "접사";
									else if(pos.equals("ꃁ")) pos = "어미";
									else if(pos.equals("준")) pos = "준말";
									line += '"' + pos + '"'; //suppos
									}
									if(!(senseRs.getString("subpos") == null) && !senseRs.getString("subpos").equals("")){ //suppos랑 subpos에 둘 다 있을때만
											line += ", ";
											line += '"' + senseRs.getString("subpos") + '"'; //subpos
									}
									line += ">";*/
									
									if(!(senseRs.getString("suppos") == null) && !senseRs.getString("suppos").equals("")){
										line += "			<SUPPOS LOCATION=";
										//if()//front-back 추가하기
										line += ">";
										line += senseRs.getString("suppos");
										line += "</SUPPOS>\r\n";
									}
	
									if(!(senseRs.getString("subpos") == null) && !senseRs.getString("subpos").equals("")){
										line += "			<SUBPOS LOCATION=";
										//if()//front-back 추가하기
										line += ">";
										line += senseRs.getString("subpos");
										line += "</SUBPOS>\r\n";
									}
									
									if(!(senseRs.getString("technic") == null) && !senseRs.getString("technic").equals("")){
									line += "			<TECH_INFO LOCATION=";
									//if()//front-back 추가하기
									line += ">";
									line += senseRs.getString("technic");
									line += "</TECH_INFO>\r\n";
									}
									else if(!(senseRs.getString("explan_technic") == null) && !senseRs.getString("explan_technic").equals("")){
										line += "			<TECH_INFO LOCATION=";
										//if()//front-back 추가하기
										line += ">";
										line += senseRs.getString("explan_technic");
										line += "</TECH_INFO>\r\n";
									}
									
									//ADD DEFINITION
	
									if(!(senseRs.getString("grp1st") == null) && !senseRs.getString("grp1st").equals("")){
										line += "			<CLASS_1ST>";
										line += senseRs.getString("grp1st");
										line += "</CLASS_1ST>\r\n";
									}
									if(!(senseRs.getString("grp2nd") == null) && !senseRs.getString("grp2nd").equals("")){
										line += "			<CLASS_2ND>";
										line += senseRs.getString("grp2nd");
										line += "</CLASS_2ND>\r\n";
									}
									if(!(senseRs.getString("grp3rd") == null) && !senseRs.getString("grp3rd").equals("")){
										line += "			<CLASS_3RD>";
										line += senseRs.getString("grp3rd");
										line += "</CLASS_3RD>\r\n";
									}
									if(!(senseRs.getString("grp4th") == null) && !senseRs.getString("grp4th").equals("")){
										line += "			<CLASS_4TH>";
										line += senseRs.getString("grp4th");
										line += "</CLASS_4TH>\r\n";
									}
	
									if(!(senseRs.getString("pattern") == null) && !senseRs.getString("pattern").equals("")){
										line += "			<PAT_INFO>";
										line += senseRs.getString("pattern"); //pattern
										line += "</PAT_INFO>\r\n";
									}
									if(!(senseRs.getString("restric") == null) && !senseRs.getString("restric").equals("")){
										line += "			<RES_INFO>";
										line += senseRs.getString("restric") + " ";//restric
										line += "</RES_INFO>\r\n";
									}
									if(!(senseRs.getString("semantic") == null) && !senseRs.getString("semantic").equals("")){
										line += "			<SEM_INFO>";
										line += senseRs.getString("semantic") + " "; //semantic
										line += "</SEM_INFO>\r\n";
									}
									if(!(senseRs.getString("theta") == null) && !senseRs.getString("theta").equals("")){
										line += "			<THE_INFO>";
										line += senseRs.getString("theta") + " "; //theta
										line += "</THE_INFO>\r\n";
									}
									if(!(senseRs.getString("explan_explan") == null) && !senseRs.getString("explan_explan").equals("")){
										line += "			<SENSE>";
										line += senseRs.getString("explan_explan"); //explan_explan
										line += "</SENSE>\r\n";
									}
	
									/*if(!(senseRs.getString("useform") == null) && !senseRs.getString("useform").equals("")){
										line += "					<USEFORM>";
										line += senseRs.getString("useform");
										line += "</USEFORM>\r\n";
									}*/
	
									if(!(senseRs.getString("example") == null) && !senseRs.getString("example").equals("")){
										line += "			<EXAMPLE>";
										line += senseRs.getString("example");
										line += "</EXAMPLE>\r\n";
									}
	
									if(!(senseRs.getString("stype") == null) && !senseRs.getString("stype").equals("")){ //rterm 이 있는 경우만
										line += "			<RTERMS>\r\n";
										//rterm들 모두 뽑기(senseRs 에서)
										query = "select stype, reid, ronum, stdword from " + tableName.get(i) + " where eid =" + senseRs.getString("eid") +" and explan_onum = " +senseRs.getString("explan_onum");
										statement = conn.prepareStatement(query);
										rtermRs = statement.executeQuery();
										checked3.clear();
										check3 = false;
										while(rtermRs.next()){
											for(int m = 0; m<checked3.size();m++){ //이미 추출한 rterm 인지 검사
												String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
												if(a.equals(checked3.get(m))){
													check3 = true;
													break;
												}else check3 = false;
											}
											if(check3 == false){
													query = "select ohw, onum, origin, glevel, grp1st, grp2nd, grp3rd, grp4th from " + tableName.get(i) + " where eid = " + rtermRs.getString("reid") + " and explan_onum = " + rtermRs.getString("ronum"); //관련어의 ohw 뽑기
													statement = conn.prepareStatement(query);
													rtermOhw = statement.executeQuery();
													if(rtermOhw.next()){
														String a = rtermRs.getString("reid") + rtermRs.getString("ronum");
														checked3.add(a);
														line += "				<RTERM EID=" + '"' + rtermRs.getString("reid") + '"';
														line += " TYPE=" + '"' + rtermRs.getString("stype") + '"';
														line += " SUP=" + '"' + rtermOhw.getString("onum") + '"';
														line += " ORG=" + '"' + rtermOhw.getString("origin") + '"';
														line += " SUB=" + '"' + rtermOhw.getString("grp1st") + rtermOhw.getString("grp2nd") + rtermOhw.getString("grp3rd") + rtermOhw.getString("grp4th") +'"';
														line += ">" + rtermOhw.getString("ohw") + "</RTERM>\r\n";
													}
												}
										}
										line += "			</RTERMS>\r\n";
									}
									line += "		</DEFINITION>\r\n";
								}
							}
							//같은 품사 안에 쭉 적기	
						}
						if(senseRs.isLast()){
							line += "	</DEFINITIONS>\r\n";
						}
					}
					
					//END DEFINITIONS
					
					//IDIOMS
					if(!(rs2.getString("idiom") == null) && !rs2.getString("idiom").equals("")){ //idiom이 있는 경우만

						line += "	<IDIOMS>\r\n";
						//idiom들 모두 뽑기(rs2에서)
						query = "select idiom_uid, idiom, idiom_explan from " + tableName.get(i) + " where eid =" + rs2.getString("eid");
						
						statement = conn.prepareStatement(query);
						idiomRs = statement.executeQuery();
						
						checked4.clear();
						check4 = false;
						
							while(idiomRs.next()){
								for(int n = 0; n<checked4.size();n++){ //이미 추출한 idiom 인지 검사
									if(idiomRs.getString("idiom_uid").equals(checked4.get(n))){
										check4 = true;
										break;
									}else check4 = false;
								}
								
								if(check4 == false){
									line += "		<IDIOM>\r\n";
									line += "			<IHW>" + idiomRs.getString("idiom") + "</IHW>\r\n";
									line += "			<IDEF>" + idiomRs.getString("idiom_explan") + "</IDEF>\r\n";
									line += "		</IDIOM>\r\n";
									checked4.add(idiomRs.getString("idiom_uid"));//검사한 uid 추가
								}
								if(idiomRs.isLast()){
									line += "	</IDIOMS>\r\n";
									}
							}
						}
					
					//PROVERBS
					if(!(rs2.getString("proverb") == null) && !rs2.getString("proverb").equals("")){ //proverb가 있는 경우만

					line += "	<PROVERBS>\r\n";
					//idiom들 모두 뽑기(rs2에서)
					query = "select proverb_uid, proverb, proverb_explan from " + tableName.get(i) + " where eid =" + rs2.getString("eid");
					
					statement = conn.prepareStatement(query);
					proverbRs = statement.executeQuery();
					
					checked5.clear();
					check5 = false;
					
						while(proverbRs.next()){
							for(int l = 0; l<checked5.size();l++){ //이미 추출한 proverb인지 검사
								if(proverbRs.getString("proverb_uid").equals(checked5.get(l))){
									check5 = true;
									break;
								}else check5 = false;
							}
							
							if(check5 == false){
								line += "		<PROVERB>\r\n";
								line += "			<PHW>" + proverbRs.getString("proverb") + "</PHW>\r\n";
								line += "			<PDEF>" + proverbRs.getString("proverb_explan") + "</PDEF>\r\n";
								line += "		</PROVERB>\r\n";
								checked5.add(proverbRs.getString("proverb_uid"));//검사한 uid 추가
							}
							if(proverbRs.isLast()){
								line += "	</PROVERBS>\r\n";
							}
						}
					}
					/*if(!(rs2.getString("idiom") == null) && !rs2.getString("idiom").equals("")){ //idiom이 있는 경우만

						line += "	<IDIOMS>\r\n";
			
						query = "select idiom_uid, idiom, idiom_explan from " + tableName.get(i) + " where eid =" + rs2.getString("eid"); //eid에 해당하는 idiom 뽑기
	
						statement = conn.prepareStatement(query);
						idiomRs = statement.executeQuery();
				
						if(idiomRs.next()){
							line += "		<IDIOM>\r\n";
							line += "			<IHW>" + idiomRs.getString("idiom") + "</IHW>\r\n";
							line += "			<IDEF>" + idiomRs.getString("idiom_explan") + "</IDEF>\r\n";
							line += "		<IDIOM>\r\n";
							}
						line += "	</IDIOMS>\r\n";
					}*/
					
					line += "</ENTRY>";
					bw.write(line);
					bw.newLine();
					line= ""; 	//line초기화
				}
				
			}
			
			fieldName.clear();
			//rs2.clear();
		}
		writer.print("Finished");
		//rs.getString("lex_kuck_step").equals("등록")
		//writer.close();
	
		
	}catch (Exception e) {
		writer.print("#Exception: " + e.getMessage());
		writer.close();
  	} finally {
		try {
			if (statement != null) statement.close();
			if (conn != null) conn.close();
			
			if (bw != null) bw.close();
			/*
		    bwA.close();
			bwB.close();
			bwC.close();
			bwD.close();
			bwE.close();
			bwF.close();
			*/
		} catch (SQLException sqle) {
			writer.print("#Exception SQL close: " + sqle.getMessage());
			writer.close();
		}
 	}
 	
%>