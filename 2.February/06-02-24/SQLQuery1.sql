select YEAR(PublishDate) Y, month(PublishDate) M, day(PublishDate) D, count(1)
from dbo_jobpostings 
where verified = 1 and PublishDate >= '1/1/2024'
	and CVReceivingOptions like '%1%'
group by YEAR(PublishDate), month(PublishDate), day(PublishDate)
order by Y desc,M desc, D desc