<%@ page import="java.util.*" %>
<%@ page import="zxyw50.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.Locale" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.ServletContext" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="javax.servlet.jsp.PageContext" %>

<%!
   /**\u663E\u793A\u94C3\u97F3\u4EF7\u683C\uFF0C\u5C06\u5206\u8F6C\u5316\u4E3A\u5143
    * @param str    \u94C3\u97F3\u4EF7\u683C(\u5206)
    * @return String   \u94C3\u97F3\u4EF7\u683C(\u5143)
    * @author mgb 2004.01.05
    */
  public String displayFee (String ringFee) {

       return ringFee;
    }

  /**
    * \u83B7\u53D6\u5B57\u7B26\u4E32\u7684\u5B57\u8282\u957F\u5EA6
    * @param       str     \u5B57\u7B26\u4E32
    * @return      int   \u5B57\u7B26\u4E32\u7684\u5B57\u8282\u957F\u5EA6
    * @author      mgb 2004.12.30
    */
   public int getStringLength (String str) {
       if (str == null)
           return 0;
       byte[] bytes = str.getBytes();
       return bytes.length;
   }


   /**
    * \u622A\u53D6\u663E\u793A\u6307\u5B9A\u957F\u5EA6\u7684\u5B57\u7B26\u4E32
    * @param       str      \u5B57\u7B26\u4E32
    * @param       length   \u663E\u793A\u7684\u5B57\u7B26\u4E32\u5B57\u8282\u957F\u5EA6
    * @return       \u622A\u53D6\u540E\u7684\u5B57\u7B26\u4E32
    * @author      mgb 2004.12.30
    */
     public  String getLimitString (String str, int length) {
       if (str == null || length <=0)
           return "";
       int iLength = getStringLength(str);
       if(iLength<length)
           return str;
       String sTmp = getString(str,0,length-2);
       return sTmp + "..";
    }


   /**
    * \u663E\u793A\u94C3\u97F3\u540D\u79F0
    * @param       str      \u94C3\u97F3\u540D\u79F0
    * @return      String   \u622A\u53D6\u540E\u7684\u94C3\u97F3\u540D\u79F0
    * @author      mgb 2004.12.30
    */
    public String displayRingName (String ringName) {
        int    RINGNAME_LENGTH = 20; //\u5B57\u8282\u957F\u5EA6
        return  getLimitString(ringName,RINGNAME_LENGTH);
    }

   /**
    * \u663E\u793A\u6B4C\u624B\u540D\u79F0
    * @param       str      \u6B4C\u624B\u540D\u79F0
    * @return      String   \u622A\u53D6\u540E\u7684\u6B4C\u624B\u540D\u79F0
    * @author      mgb 2004.12.30
    */
    public String displayRingAuthor (String ringName) {
        int    SPNAME_LENGTH = 10; //\u5B57\u8282\u957F\u5EA6
        return  getLimitString(ringName,SPNAME_LENGTH);
    }


    /**
    * \u663E\u793A\u94C3\u97F3\u6307\u5B9A\u5546
    * @param       str      \u94C3\u97F3\u6307\u5B9A\u5546
    * @return      String   \u622A\u53D6\u540E\u7684\u94C3\u97F3\u6307\u5B9A\u5546
    * @author      mgb 2004.12.30
    */
     public String displaySpName (String ringName) {
	    int    SPNAME_LENGTH = 10;  //\u5B57\u8282\u957F\u5EA6
        return  getLimitString(ringName,SPNAME_LENGTH);
	}



    /**
     * \u68C0\u67E5\u5B57\u7B26\u4E32\u5B57\u8282\u957F\u5EA6\u662F\u5426\u6BD4\u6307\u5B9A\u7684\u957F
     * @param       str   \u5B57\u7B26\u4E32
     * @param       len   \u6BD4\u8F83\u957F\u5EA6
     * @return      true: \u6BD4\u6307\u5B9A\u957F\u5EA6\u957F
     * @author      mgb 2004.12.30
     */
     public boolean checkLen(String str, int len){
		return getStringLength(str) >len?true:false ;
      }

      /**
       * \u622A\u53D6\u4E00\u6BB5\u5B57\u7B26\u7684\u957F\u5EA6,\u4E0D\u533A\u5206\u4E2D\u82F1\u6587,\u5982\u679C\u6570\u5B57\u4E0D\u6B63\u597D\uFF0C\u5219\u5C11\u53D6\u4E00\u4E2A\u5B57\u7B26\u4F4D
       * @param  String origin, \u539F\u59CB\u5B57\u7B26\u4E32
       * @param  int begin, \u5F00\u59CB\u4F4D\u7F6E
       * @param  int len, \u622A\u53D6\u957F\u5EA6(\u4E00\u4E2A\u6C49\u5B57\u957F\u5EA6\u63092\u7B97\u7684)
       * @return String, \u8FD4\u56DE\u7684\u5B57\u7B26\u4E32
       */
     public String getString(String origin, int begin, int len) {
       String  str = "";
       if (origin == null)
            return str;
       int sBegin = (begin < 0)?0:begin;
       if (len < 1 || sBegin > origin.length())
          return "";
       if (len/2 + sBegin > origin.length())
          return origin.substring(sBegin);
       char[] c = origin.toCharArray();
       StringBuffer sb = new StringBuffer();
       for (int i = sBegin,j = sBegin; i < (sBegin + len); i++,j++){
          if (j >= c.length) break;
          if (!isLetter(c[j]))
            i++;
          if(i < (sBegin + len))
            sb.append(c[j]);
       }
       return sb.toString();
    }

     /**
      * \u5224\u65AD\u4E00\u4E2A\u5B57\u7B26\u662FAscill\u5B57\u7B26\u8FD8\u662F\u5176\u5B83\u5B57\u7B26\uFF08\u5982\u6C49\uFF0C\u65E5\uFF0C\u97E9\u6587\u5B57\u7B26\uFF09
      * @param char c, \u9700\u8981\u5224\u65AD\u7684\u5B57\u7B26
      * @return boolean, \u8FD4\u56DEtrue,Ascill\u5B57\u7B26
      */
    public static boolean isLetter(char c) {
          int k = 0x80;
          return c/k == 0?true:false;
    }



   /** \u5C06Ascill\u5B57\u7B26\u8F6C\u6362\u6210\u6C49\u5B57\u5B57\u7B26
    * @param str Ascill\u5B57\u7B26\u4E32
    * @return String \u6C49\u5B57\u5B57\u7B26\u4E32
    */
    public String transferString(String str) throws Exception {
      if(str==null)str="";
      return str;
    }

  /**\u663E\u793A\u94C3\u97F3\u4EF7\u683C\uFF0C\u5C06\u5206\u8F6C\u5316\u4E3A\u5143
   * @param str    \u94C3\u97F3\u4EF7\u683C(\u5206)
   * @return String   \u94C3\u97F3\u4EF7\u683C(\u5143)
   * @author mgb 2004.01.05
   */
   public String formatFee (String str) {
      
       return str;

    }

  /**\u7BA1\u7406\u7CFB\u7EDF\u5BF9\u591Ascp\u64CD\u4F5C\u8FD4\u56DE\u7ED3\u679C\u7684\u5224\u65AD\u662F\u5426\u6210\u529F
   * @param rList     \u6267\u884C\u7ED3\u679C
   * @return boolean  \u6267\u884C\u662F\u5426\u6210\u529F\uFF08\u4E3Bscp\u64CD\u4F5C\u6210\u529F\u5219\u4E3A\u6210\u529F\uFF0C\u5426\u5219\u5931\u8D25\uFF09
   * @author mgb 2005.01.07
   */
   public boolean getResultFlag(ArrayList rList) {
       boolean flag = false;
       if(rList == null) return flag;
       Hashtable hash = (Hashtable)rList.get(0);
       if(hash !=null && ((String)hash.get("result")).equals("0"))
          flag = true;
        return flag;
   }

   public String displaySex(String sexring){
      String displaystring="";
      if(sexring.equalsIgnoreCase("0"))
        displaystring="Male";
      else
        displaystring="Female";
        try{
          displaystring=transferString(displaystring);
        }catch(Exception e){
         e.printStackTrace();
        }
        return displaystring;
   }

   public String displayWeekstar(String weekstar){
    String displaystring="";
      if(weekstar.equalsIgnoreCase("0"))
        displaystring="No";
      else
        displaystring="Yes";
        try{
          displaystring=transferString(displaystring);
        }catch(Exception e){
         e.printStackTrace();
        }
        return displaystring;
   }

   public boolean checkP(String phone){
     boolean flag = false;
     if(!(phone.length()>9) &&(phone.length()>2)&& !(phone.substring(0,2).equals("13"))&&
        !(phone.substring(0,2).equals("14"))&&!(phone.substring(0,2).equals("15"))&&
        !(phone.substring(0,1).equals("0"))){
       flag = true;
     }
     return flag;
   }
      public Locale getLocale(javax.servlet.jsp.PageContext pageContext)
   {
        Locale locale = (Locale)pageContext.findAttribute("ZteCrbtLocale");
        if (locale != null) {
            return locale ;
        }
		locale = pageContext.getRequest().getLocale();
		if( com.zte.tao.util.StringUtil.contains(com.zte.tao.config.TaoUtil.getLangPool(),locale.toString())==true )
		{
			return locale ;
		}
		else
		{
			locale = new Locale(pageContext.getRequest().getLocale().getLanguage(),"");
			if( com.zte.tao.util.StringUtil.contains(com.zte.tao.config.TaoUtil.getLangPool(),locale.toString())==true )
			{
				return locale ;
			}
			else
			{
				locale = com.zte.tao.config.TaoUtil.getDefLocale();
				HttpSession session = pageContext.getSession();
                session.setAttribute("ZteCrbtLocale", locale);
				//WebUtils.setLocale((HttpServletRequest) pageContext.getRequest(), (HttpServletResponse) pageContext.getResponse(), locale);
			}
		}
        return locale;
    }

    public static Locale getZteLocale(HttpServletRequest request)
	{
		return com.zte.tao.config.TaoUtil.getZteLocale(request);
  }

/**
	   *
	   * @param request HttpServletRequest	   *
	   * @param Key String
	   *        information Key ID
	   * @param type String
	   *        1 , user interface; 2, group interface; 3 ,manager interface; 4, SP
	   * @return String
	   *        the value corresponding to information Key
	   */

      public static String getArgMsg(HttpServletRequest request, String key, String type) {
        String value = "";
		try
		{
    		ResourceBundle rblib;
			String jsplib="";
    		if( type.trim().equals("1") )
				jsplib = "com/zte/i18nres/txtres/userjsp";
			else  if( type.trim().equals("2") )
				jsplib = "com/zte/i18nres/txtres/grpjsp";
			else  if( type.trim().equals("3") )
				jsplib = "com/zte/i18nres/txtres/mgrjsp";
			else  if( type.trim().equals("4") )
				jsplib = "com/zte/i18nres/txtres/spjsp";
			else
				jsplib = "com/zte/i18nres/txtres/userjsp";

			rblib = ResourceBundle.getBundle(jsplib, getZteLocale(request));
			value = rblib.getString(key);
		}
		catch(Exception e)
		{
   		    System.out.println("JavaFun.jsp, getMessage exception, language="+request.getLocale().getLanguage()+" key=" + key + " type=" + type);
		}
        return value;
    }

      public static String getArgMsg(HttpServletRequest request, String key, String type, String var1) {
        String str = "";
		try
		{
			str= getArgMsg( request,  key, type);
      		if(var1!=null)
        		str=str.replaceAll("\\{\\$1\\}",var1);
		}
		catch(Exception e)
		{
   		    System.out.println("getArgMsg exception, language="+request.getLocale().getLanguage()+" key=" + key + " type=" + type+"var1="+var1);
		}
        return str;
    }

    public static String getArgMsg(HttpServletRequest request, String key, String type, String var1,String var2) {
        String str = "";
		try
		{
			str= getArgMsg( request,  key, type);
      		if(var1!=null)
        		str=str.replaceAll("\\{\\$1\\}",var1);
      		if(var2!=null)
        		str=str.replaceAll("\\{\\$2\\}",var2);
		}
		catch(Exception e)
		{
   		    System.out.println("getArgMsg exception, language="+request.getLocale().getLanguage()+" key=" + key + " type=" + type+"var1="+var1+"var2="+var2);
		}
        return str;
    }

    public static String getLocaleShow(HttpServletRequest request, String type, String var1 ) {
		if( var1.equalsIgnoreCase("zh_CN") )
		{
			return getArgMsg(request,"UserMSG0059000","1");
		}
		else if( var1.equalsIgnoreCase("zh") )
		{
			return getArgMsg(request,"UserMSG0059001","1");
		}
		else if( var1.equalsIgnoreCase("en") || var1.trim().startsWith("en_") )
		{
			return getArgMsg(request,"UserMSG0059002","1");
		}
		else if( var1.equalsIgnoreCase("ar") || var1.trim().startsWith("ar_") )  //arabic
		{
			return getArgMsg(request,"UserMSG0059003","1");
		}
		else if( var1.equalsIgnoreCase("el") )   //Greece
		{
			return getArgMsg(request,"UserMSG0059004","1");
		}
		else if( var1.equalsIgnoreCase("ru") )   //Russian
		{
			return getArgMsg(request,"UserMSG0059006","1");
		}
		else if( var1.equalsIgnoreCase("fr") )   //French
		{
			return getArgMsg(request,"UserMSG0059007","1");
		}
                else if( var1.equalsIgnoreCase("bn") )   //French
		{
			return getArgMsg(request,"UserMSG0059008","1");
		}
		  else if( var1.equalsIgnoreCase("am") )   //Amharic
		{
			return getArgMsg(request,"UserMSG0059009","1");
		}
		else if( var1.equalsIgnoreCase("ht") )   //Haiti Creole
		{
			return getArgMsg(request,"UserMSG0059010","1");
		}
   	       else if( var1.equalsIgnoreCase("mo") )   //Montenegro
		{
				return getArgMsg(request,"UserMSG0059011","1");
		}else if( var1.equalsIgnoreCase("mn") )   //Mongolia
		{
			return getArgMsg(request,"UserMSG0059012","1");
		}
                else if( var1.equalsIgnoreCase("fa") )   //Persian or Farsi
		{
				return getArgMsg(request,"UserMSG0059013","1");
		}
		else
			return getArgMsg(request,"UserMSG0059005","1");
    }

    public static String getLocaleShow(HttpServletRequest request, String type, Locale locvar ) {
		return getLocaleShow(request,"1",locvar.toString());
	}

    
    
    public  HashMap getPaginationLinks(HashMap input) {
	 	   HashMap output = new HashMap();
	 		if (input == null) {
	 			System.out.println(">> getModel() Received invalid Input >page Model object : " + input);
	 		} else {
	 				if((String)input.get("PAGESIZE")==null || (String)input.get("RESULTTOTAL")==null || (String)input.get("TOTALPAGES")==null || (String)input.get("PAGELINKS")==null){
	 					return output;
	 				} 			
	 			//System.out.println(">> getModel() Received  Input >page Model object : " + input);
	 			int pageNumber=Integer.parseInt((String)input.get("REQPAGE"));
	 			//System.out.println(">> getModel() received Input >pageNumber : " + pageNumber);
	 			//TODO: page size 
	 			//No of objects per page
	 			final int pageSize = Integer.parseInt((String)input.get("PAGESIZE"));
	 			final int resultTotal=Integer.parseInt((String)input.get("RESULTTOTAL"));
	 			final int totalPages=Integer.parseInt((String)input.get("TOTALPAGES"));
	 			final int pageLinks=Integer.parseInt((String)input.get("PAGELINKS"));
	 			
	 			final int pagesTotal =totalPages==0?(resultTotal%pageSize>0?(resultTotal/pageSize+1):resultTotal/pageSize):totalPages;
	 			
	 			//TODO: page link size need to get from properties file
	 			final int viewPages = pageLinks;

	 			int centerPage = viewPages / 2;
	 			/*if (viewPages%2==0)
	 				centerPage++;*/
	 			final int reminderPage = viewPages % 2;

	 			if (pageNumber <= 0) {
	 				pageNumber = 1;
	 			}
	 			if (pageNumber > pagesTotal) {
	 				pageNumber = pagesTotal;
	 			}
	 			int pg = 0;
	 			final int pg1 = reminderPage == 0 ? 0 : 1;
	 			final int pg2 = reminderPage != 0 ? 0 : 1;
	 			final int pg3 = pageNumber < viewPages &&reminderPage != 1?  2 : 1;

	 			// Get page numbers
	 			if (pageNumber <= centerPage) {
	 				pg = (pageNumber == centerPage) ? (reminderPage == 1 ? 1 : 0)
	 						:((pageNumber < centerPage)?pg3-1: centerPage - pg3);
	 			}
	 			/*System.out.println(" --- getModel() >centerPage : " + centerPage + " >reminderPage : "
	 					+ reminderPage + " >pageNumber: " + pageNumber + " >pg :" + pg
	 					+ " >pg1 :" + pg1 + " >pg2 : " + pg2 + " >pg3 : " + pg3);*/
	 			int firstVisiblePage = pageNumber > centerPage + pg1 ? pageNumber
	 					- centerPage + pg2 : 1;

	 			int lastVisiblePage = (pageNumber + centerPage < pagesTotal && pageNumber
	 					+ centerPage + pg < pagesTotal) ? (pageNumber == 1&& viewPages>3 ? (pageNumber
	 					+ centerPage + pg+pg2+reminderPage)
	 					: (pageNumber + centerPage + pg))
	 					: pagesTotal;
	 			lastVisiblePage=lastVisiblePage>viewPages && pageNumber==1 && lastVisiblePage<=pagesTotal?viewPages:lastVisiblePage;
	 			lastVisiblePage= lastVisiblePage<viewPages && lastVisiblePage<pagesTotal?viewPages:lastVisiblePage;
	 			if (lastVisiblePage == pagesTotal) {
	 				firstVisiblePage = lastVisiblePage - (viewPages - 1) <= 0 ? 1
	 						: lastVisiblePage - (viewPages - 1);
	 			}
	 			output.put("REQPAGE",String.valueOf(pageNumber));
	 			output.put("CURPAGE",String.valueOf(pageNumber));
	 			output.put("FIRSTPAGE",String.valueOf(firstVisiblePage));
	 			output.put("LASTPAGE",String.valueOf(lastVisiblePage));
	 			output.put("TOTPAGE",String.valueOf(pagesTotal));
	 			/*System.out.println("--- getModel() >pageNumber :" + pageNumber
	 							+ " >pagesTotal :" + pagesTotal + " >pg :" + pg
	 							+ " >firstVisiblePage :" + firstVisiblePage
	 							+ " >lastvisiblePage :" + lastVisiblePage );*/
	 		}
	 		return output;
	 	}
    
	    public String getCurrentDate(){
			Calendar cal = new GregorianCalendar();
			int month = cal.get(Calendar.MONTH)+1;
			int year = cal.get(Calendar.YEAR);
			int day = cal.get(Calendar.DAY_OF_MONTH);
			String today = "2000.01.01";
			String month1 = String.valueOf(month);
			if(month < 10)
				month1 = "0"+month;
			String day1 = String.valueOf(day);
			if(day < 10)
				day1 = "0"+day;
			today = year+"."+month1+"."+day1;
			return today;
	 	}
%>
