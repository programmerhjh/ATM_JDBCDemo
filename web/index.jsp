<%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 2018/3/15
  Time: 8:39
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>ATM登陆页</title>
  </head>
  <body>
  <%
    long waitTime = 3000;
    long currentTimeMillis = System.currentTimeMillis();
    long purposeTime = currentTimeMillis + waitTime;
    if(session.getAttribute("user") != null){
        while(currentTimeMillis < purposeTime){
          out.println("您已登录，无需重复登录，" + (purposeTime - currentTimeMillis)/1000 + "秒后，返回到ATM操作页面");
          currentTimeMillis += 1000;
          out.flush();
          Thread.sleep(1000);
          out.println("<script>document.body.innerHTML=\"\";</script>");
        }
      out.println("<script>window.location.href = 'atmIndex.jsp'</script>");
    }else {
  %>
  <h1>用户登录</h1>
  <form action="atmIndex.jsp" method="post">
    <label for="username">用户名：
      <input type="text" placeholder="请输入用户名" name="username" id="username">
    </label>
    <br>
    <label for="password">密码：
      <input type="password" placeholder="请输入密码" name="password" id="password">
    </label>
    <br>
    <input type="submit" value="提交">
  </form>
  <%
    }
  %>
  </body>
</html>
