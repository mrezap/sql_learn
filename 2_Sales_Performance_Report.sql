--Buatlah Query dengan menggunakan SQL untuk mendapatkan total penjualan (sales) dan jumlah order (number_of_order) dari tahun 2009 sampai 2012 (years). 
SELECT YEAR(order_date) AS years, SUM(sales) sales, COUNT(order_quantity) AS number_of_order
FROM dqlab_sales_store
WHERE YEAR(order_date) BETWEEN 2009 AND 2012
AND order_status = "Order Finished"
GROUP BY 1

/*Buatlah Query dengan menggunakan SQL untuk mendapatkan total penjualan (sales) 
berdasarkan sub category dari produk (product_sub_category) pada tahun 2011 dan 2012 saja (years)*/
SELECT YEAR(order_date) AS years, product_sub_category, SUM(sales) AS sales
FROM dqlab_sales_store
WHERE YEAR(order_date) IN (2011,2012) AND order_status = "Order Finished"
GROUP BY 1,2
ORDER BY 1 ASC, 3 DESC

/*Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini
Efektifitas dan efisiensi dari promosi yang dilakukan akan dianalisa berdasarkan Burn Rate yaitu dengan membandigkan 
total value promosi yang dikeluarkan terhadap total sales yang diperoleh
DQLab berharap bahwa burn rate tetap berada diangka maskimum 4.5%
Formula untuk burn rate : (total discount / total sales) * 100
Buatkan Derived Tables untuk menghitung total sales (sales) dan total discount (promotion_value)
berdasarkan tahun(years) dan formulasikan persentase burn rate nya (burn_rate_percentage)*/
SELECT YEAR(order_date) AS years, SUM(sales) AS sales, SUM(discount_value) AS promotion_value, 
ROUND(SUM(discount_value)/SUM(sales)*100,2) AS burn_rate_percentage
FROM dqlab_sales_store
WHERE order_status = "Order Finished"
GROUP BY 1

/*by Product Sub Category*/
SELECT YEAR(order_date) AS years, product_sub_category, product_category, SUM(sales) AS sales, 
SUM(discount_value) AS promotion_value, ROUND(SUM(discount_value)/SUM(sales)*100,2) AS burn_rate_percentage
FROM dqlab_sales_store
WHERE YEAR(order_date) = 2012 AND order_status = "Order Finished"
GROUP BY 1,2,3
ORDER BY 4 DESC

--DQLab Store ingin mengetahui jumlah customer (number_of_customer) yang bertransaksi setiap tahun dari 2009 sampai 2012 (years).
SELECT YEAR(order_date) AS years, COUNT(DISTINCT customer) AS number_of_customer
FROM dqlab_sales_store
WHERE order_status = "Order Finished"
GROUP BY 1
