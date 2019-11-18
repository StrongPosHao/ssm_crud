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
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>
<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span id="helpBlock" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@example.com">
                            <span id="helpBlock1" class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!-- 部门提交部门id即可 -->
                            <select class="form-control" name="dId" id="dept_add_select">

                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

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
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
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
        <div class="col-md-6" id="page_info_area"></div>
        <!--分页条信息-->
        <div class="col-md-6" id="page_nav_area">
            <script type="text/javascript">

                var totalRecord;
                // 1.页面加载完成以后，直接发送一个ajax请求，要到分页数据
                $(function () {
                    // 去首页
                    to_page(1);
                });
                
                function to_page(pn) {
                    $.ajax({
                        url:"${APP_PATH}/emps",
                        data:"pn=" + pn,
                        type:"GET",
                        success:function (result) {
                            // console.log(result);
                            // 1.解析并显示员工数据
                            build_emps_table(result);
                            // 2.解析并显示分页信息
                            build_page_info(result);
                            // 3.解析显示分页条数据
                            build_page_nav(result);
                        }
                    });
                }

                function build_emps_table(result) {
                    // 清空table表格
                    $("#emps_table tbody").empty();
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

                // 解析显示分页信息
                function build_page_info(result) {
                    $("#page_info_area").empty();
                    $("#page_info_area").append("当前" + result.extend.pageInfo.pageNum + "页, 总共" +
                        result.extend.pageInfo.pages + "页, 共" + result.extend.pageInfo.total + "条记录")
                    totalRecord = result.extend.pageInfo.total;
                }

                // 解析显示分页条, 点击分页要能去下一页...
                function build_page_nav(result) {
                    // page_nav_area
                    $("#page_nav_area").empty();
                    var ul = $("<ul></ul>").addClass("pagination");

                    // 构建元素
                    var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
                    var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
                    if (result.extend.pageInfo.hasPreviousPage == false) {
                        firstPageLi.addClass("disabled");
                        prePageLi.addClass("disabled");
                    } else {
                        // 为元素添加点击翻页的事件
                        firstPageLi.click(function () {
                            to_page(1);
                        });
                        prePageLi.click(function () {
                            to_page(result.extend.pageInfo.pageNum - 1);
                        });
                    }

                    var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
                    var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
                    if (result.extend.pageInfo.hasNextPage == false) {
                        nextPageLi.addClass("disabled");
                        lastPageLi.addClass("disabled");
                    } else {
                        nextPageLi.click(function () {
                            to_page(result.extend.pageInfo.pageNum + 1);
                        });
                        lastPageLi.click(function () {
                            to_page(result.extend.pageInfo.pages);
                        });
                    }
                    //添加首页和前一页的提示
                    ul.append(firstPageLi).append(prePageLi);
                    // 1, 2, 3遍历给ul中添加页码提示
                    $.each(result.extend.pageInfo.navigatepageNums, function(index, item) {
                        var numLi = $("<li></li>").append($("<a></a>").append(item));
                        if (result.extend.pageInfo.pageNum == item) {
                            numLi.addClass("active");
                        }
                        numLi.click(function () {
                            to_page(item);
                        });
                        ul.append(numLi);
                    });
                    // 添加下一页和末页的提示
                    ul.append(nextPageLi).append(lastPageLi);

                    // 把ul加入nav
                    var navEle = $("<nav></nav>").append(ul);
                    navEle.appendTo("#page_nav_area");
                }
                // 点击新增按钮弹出模态框
                $("#emp_add_modal_btn").click(function () {
                    // 发出ajax请求，查出部门信息，显示在下拉列表中
                    getDepts();
                    // 弹出模态框
                    $("#empAddModal").modal({
                      backdrop: "static"
                   });

                });

                function getDepts() {
                    $.ajax({
                        url: "${APP_PATH}/depts",
                        type: "GET",
                        success: function (result) {
                            // console.log(result);
                            // 显示部门信息在下拉列表中
                            // $("#empAddModal select").append("")
                            $.each(result.extend.depts, function () {
                                var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                                optionEle.appendTo("#empAddModal select");
                            });
                        }
                    });
                }

                // 校验表单数据
                function validate_add_form() {
                    // 1. 拿到要校验的数据，使用正则表达式
                    var empName = $("#empName_add_input").val();
                    var regName = /(^[A-Za-z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
                    if (!regName.test(empName)) {
                        // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
                        show_validate_msg("#empName_add_input", "error", "用户名可以是2-5位中文或者6-16位英文和数字的组合");
                        return false;
                    } else {
                        show_validate_msg("#empName_add_input", "success", "");
                    }
                    // 2、校验邮箱信息
                    var email = $("#email_add_input").val();
                    var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
                    if (!regEmail.test(email)) {
                        // alert("邮箱格式不正确");
                        // 应该清空这个元素之前的样式
                        show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
                        return false;
                    } else {
                        show_validate_msg("#email_add_input", "success", "");
                    }
                    return true;
                }

                function show_validate_msg(ele, status, msg) {
                    // 清楚当前元素的校验状态
                    $(ele).parent().removeClass("has-success has-error");
                    $(ele).next("span").text("");
                    if ("success" == status) {
                        $(ele).parent().addClass("has-success");
                        $(ele).next("span").text("");
                    } else if ("error" == status) {
                        $(ele).parent().addClass("has-error");
                        $(ele).next("span").text(msg);
                    }
                }

                // 点击保存，保存员工
                $("#emp_save_btn").click(function () {
                    //1.模态框中填写的表单数据提交给服务器进行保存
                    //1、先对要提交给服务器的数据进行校验
                    if (!validate_add_form()) {
                        return false;
                    }
                    //2.发送ajax请求保存员工
                    $.ajax({
                        url: "${APP_PATH}/emp",
                        type: "POST",
                        data: $("#empAddModal form").serialize(),
                        success: function(result) {
                            // alert(result.msg);
                            // 员工保存成功
                            // 1.关闭模态框
                            $("#empAddModal").modal("hide");

                            // 2.来到最后一页，显示刚才保存的资源
                            // 发送ajax请求显示最后一夜数据即可
                            to_page(totalRecord);
                        }
                    });
                });

            </script>
        </div>
    </div>

</div>

</body>
</html>
