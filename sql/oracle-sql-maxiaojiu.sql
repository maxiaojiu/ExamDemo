--------------第1题
------（1）统计20171001至20171007期间累计访问pv大于100的男性用户数。
select count(distinct msisdn)  manNum
from(
      select a.msisdn,sum(pv) as pv
      from pagevisit a,user_info b
	    where a.record_day>='20171001'
	    and a.record_day <='20171007'
	    and a.msisdn=b.msisdn
	    and b.sex='男'
	    group by a.msisdn)info
where pv>100;
---------（2）统计20171001至20171007期间至少连续3天有访问的用户清单
	   
select distinct c.msisdn 
from pagevisit a,pagevisit b,pagevisit c
where a.record_day>='20171001' and a.record_day <='20171007'
and b.record_day>='20171001' and b.record_day <='20171007'
and c.record_day>='20171001' and c.record_day <='20171007'
and a.msisdn=b.msisdn
and a.msisdn=c.msisdn
and a.record_day = b.record_day+1
and b.record_day= c.record_day+1;
--------------------------------------------------------
--------第2题
--------（1）统计每个部门中薪酬排名top3的用户列表（注：存在多人薪酬相同的情况，如前四人薪酬分别为10万，8万，8万，7万，则返回的结果包含此四人）
---------输出以下信息：部门名称|员工姓名|薪酬
select dept_name||'|'|| name||'|'||salary as "部门名称|员工姓名|薪酬"
from(
	 select a.*,b.dept_name,
		   dense_rank() OVER (PARTITION BY departmentID ORDER BY coalesce(salary,0) DESC) rank
	 from employee a,department b
	 where a.departmentID=b.departmentID)info
where rank<=3;
-------------------------------------
---第3题
-----------(1)	写一段 SQL 统计2013-10-01日至2013-10-03日期间，每天非禁止用户的取消率。你的 SQL 语句应返回如下结果，取消率（Cancellation Rate）保留两位小数。
select Request_at day,TO_CHAR(round(cancelledNum/sumNum,2),'999999990.00') as "Cancellation Rate"
from(
      select Request_at,count(Id) as sumNum,
      count(case when Status in('CANCELLED_BY_DRIVER', 'CANCELLED_BY_CLIENT')
            then Id end) cancelledNum
      from (
            select a.*,b.Banned as c_banned,c.Banned as d_banned
            from Trips a,(
                  select User_Id,Banned  from Users  where role='CLIENT') b,(
                  select User_Id,Banned  from Users  where role='DRIVER') c
            where Request_at>='2013-10-01' and Request_at<='2013-10-03'
            and a.CLIEND_ID =b.User_Id
            and a.DRIVER_ID =c.User_Id)temp1
      where c_banned='No' and d_banned='No'
      group by Request_at
) info;

