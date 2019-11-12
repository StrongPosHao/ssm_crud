<%--
  Created by IntelliJ IDEA.
  User: zhanghao
  Date: 2019/11/11
  Time: 11:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <!-- web路径
    不以/开始的相对路径，找资源，以当前资源的路径位基准，容易出问题
    以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306),需要加上项目名：
        http://localhost:3306/crud
     -->
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-3.4.1.min.js"></script>
    <!-- 引入样式 -->
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/jquery.min.js"></script>
</head>
<body>

<!--搭建显示页面-->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <!-- 显示表格数据 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                <tr>
                    <th>#</th>
                    <th>empName</th>
                    <th>gender</th>
                    <th>email</th>
                    <th>deptName</th>
                    <th>操作</th>
                </tr>
                </thead>
            <tbody>

            </tbody>
            </table>
        </div>

    </div>
    <!-- 显示分页信息 -->
    <div class="row">
        <!--分页文字信息-->
        <div class="col-md-6">
            当前 页, 总共 页, 共 条记录
        </div>
        <!--分页条信息-->
        <div class="col-md-6">
            <script type="text/javascript">
                // 1.页面加载完成以后，直接发送一个ajax请求，要到分页数据
                $(function () {
                    $.ajax({
                        url:"${APP_PATH}/emps",
                        data:"pn=1",
                        type:"GET",
                        success:function (result) {
                            // console.log(result);
                            // 1.解析并显示员工数据
                            build_emps_table(result);
                            // 2.解析并显示分页信息
                            
                        }
                    });
                });

                function build_emps_table(result) {
                    var emps = result.extend.pageInfo.list;
                    $.each(emps, function(index, item){
                        var empIdTd = $("<td></td>").append(item.empId);
                        var empNameTd = $("<td></td>").append(item.empName);
                        var genderId = $("<td></td>").append(item.gender === 'M'?"男":"女");
                        var emailTd = $("<td></td>").append(item.email);
                        var deptNameTd = $("<td></td>").append(item.department.deptName);
                        var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
                            .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
                        var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                            .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
                        var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
                        // append方法执行完成后还是返回原来的元素
                        $("<tr></tr>").append(empIdTd)
                            .append(empNameTd)
                            .append(genderId)
                            .append(emailTd)
                            .append(deptNameTd)
                            .append(btnTd)
                            .appendTo("#emps_table tbody");
                    });
                }
                function build_page_nav() {

                }
            </script>
        </div>
    </div>

</div>

</body>
</html>
