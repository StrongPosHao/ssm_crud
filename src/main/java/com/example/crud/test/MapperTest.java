package com.example.crud.test;

import com.example.crud.bean.Department;
import com.example.crud.bean.DepartmentExample;
import com.example.crud.bean.Employee;
import com.example.crud.dao.DepartmentMapper;
import com.example.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;


/**
 * 测试dao层的工作
 * 1.导入spring test模块
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    /**
     * 测试DepartmentMapper
     */
    @Test
    public void testCRUD() {
        //1.创建SpringIOC容器
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
        //2.从容器中获取mapper
//        ioc.getBean(DepartmentMapper.class);
        System.out.println(departmentMapper);

        //1、插入几个部门
//        departmentMapper.insertSelective(new Department(null, "开发部"));
//        departmentMapper.insertSelective(new Department(null, "测试部"));

        //2、生成员工数据，进行员工插入
        employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "Jerry@example.com", 1));

        //3、批量插入多个员工; 批量，使用可以执行批量操作的sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 1000; i++) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M", uid + "@example.com", 1));
        }
        System.out.println("Success");
    }
}
