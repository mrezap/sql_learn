--Data Engineer Challenge with SQL DQLab

/*Mengacu pada table ms_produk, tampilkan daftar produk yang memiliki harga antara 50.000 and 150.000.
Nama kolom yang harus ditampilkan: no_urut, kode_produk, nama_produk, dan harga. */

SELECT no_urut, kode_produk, nama_produk, harga FROM ms_produk
WHERE harga BETWEEN 50000 AND 150000

/*Tampilkan semua produk yang mengandung kata Flashdisk.
Nama kolom yang harus ditampilkan: no_urut, kode_produk, nama_produk, dan harga. */

SELECT no_urut, kode_produk, nama_produk, harga
FROM ms_produk
WHERE nama_produk LIKE '%Flashdisk%'

/* Tampilkan hanya nama-nama pelanggan yang hanya memiliki gelar-gelar berikut: S.H, Ir. dan Drs.
Nama kolom yang harus ditampilkan: no_urut, kode_pelanggan, nama_pelanggan, dan alamat. */

SELECT no_urut, kode_pelanggan, nama_pelanggan, alamat
FROM ms_pelanggan
WHERE nama_pelanggan LIKE '%S.H%' OR nama_pelanggan LIKE '%Ir.%' OR nama_pelanggan LIKE '%Drs.%'

/* Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan dari yang terkecil ke yang terbesar (A ke Z).
Nama kolom yang harus ditampilkan: nama_pelanggan. */

SELECT nama_pelanggan
FROM ms_pelanggan
ORDER BY 1 ASC

/* Tampilkan nama-nama pelanggan dan urutkan hasilnya berdasarkan kolom nama_pelanggan dari yang terkecil ke yang terbesar (A ke Z), namun gelar tidak boleh menjadi bagian dari urutan. Contoh: Ir. Agus Nugraha harus berada di atas Heidi Goh.
Nama kolom yang harus ditampilkan: nama_pelanggan.*/
SELECT nama_pelanggan
FROM ms_pelanggan
ORDER BY
	CASE WHEN LEFT(nama_pelanggan,3) = 'Ir.' THEN SUBSTRING(nama_pelanggan,5,100)
	ELSE nama_pelanggan
	END ASC

/*Tampilkan nama pelanggan yang memiliki nama paling panjang. Jika ada lebih dari 1 orang yang memiliki panjang nama yang sama, tampilkan semuanya.
Nama kolom yang harus ditampilkan: nama_pelanggan.*/

SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) = (SELECT MAX(LENGTH(nama_pelanggan)) FROM ms_pelanggan);

/*Tampilkan nama orang yang memiliki nama paling panjang (pada row atas), dan nama orang paling pendek (pada row setelahnya). Gelar menjadi bagian dari nama. Jika ada lebih dari satu nama yang paling panjang atau paling pendek, harus ditampilkan semuanya.
Nama kolom yang harus ditampilkan: nama_pelanggan.*/

SELECT nama_pelanggan
FROM ms_pelanggan
WHERE LENGTH(nama_pelanggan) IN (
(SELECT MAX(LENGTH(nama_pelanggan)) FROM ms_pelanggan), (SELECT MIN(LENGTH(nama_pelanggan)) FROM ms_pelanggan))
ORDER BY LENGTH(nama_pelanggan) DESC

/*Tampilkan produk yang paling banyak terjual dari segi kuantitas. Jika ada lebih dari 1 produk dengan nilai yang sama, tampilkan semua produk tersebut.
Nama kolom yang harus ditampilkan: kode_produk, nama_produk,total_qty.*/

SELECT a.kode_produk, a.nama_produk, SUM(b.qty) AS total_qty
FROM ms_produk a
JOIN tr_penjualan_detail b
ON a.kode_produk = b.kode_produk
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 2

/*Siapa saja pelanggan yang paling banyak menghabiskan uangnya untuk belanja? Jika ada lebih dari 1 pelanggan dengan nilai yang sama, tampilkan semua pelanggan tersebut.
Nama kolom yang harus ditampilkan: kode_pelanggan, nama_pelanggan, total_harga*/

SELECT a.kode_pelanggan, a.nama_pelanggan, SUM(c.qty * c.harga_satuan) AS total_harga
FROM ms_pelanggan a
JOIN tr_penjualan b
ON a.kode_pelanggan = b.kode_pelanggan
JOIN tr_penjualan_detail c
ON b.kode_transaksi = c.kode_transaksi
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 1

/*Tampilkan daftar pelanggan yang belum pernah melakukan transaksi.
Nama kolom yang harus ditampilkan: kode_pelanggan, nama_pelanggan, alamat.*/

SELECT a.kode_pelanggan, a.nama_pelanggan, a.alamat
FROM ms_pelanggan a
LEFT JOIN tr_penjualan b
ON a.kode_pelanggan = b.kode_pelanggan
WHERE b.kode_transaksi IS NULL

/*Tampilkan transaksi-transaksi yang memiliki jumlah item produk lebih dari 1 jenis produk. Dengan lain kalimat, tampilkan transaksi-transaksi yang memiliki jumlah baris data pada table tr_penjualan_detail lebih dari satu.
Nama kolom yang harus ditampilkan:  kode_transaksi, kode_pelanggan, nama_pelanggan, tanggal_transaksi, jumlah_detail.*/


SELECT a.kode_transaksi, a.kode_pelanggan, b.nama_pelanggan, a.tanggal_transaksi, COUNT(c.kode_transaksi) AS jumlah_detail
FROM tr_penjualan a
JOIN ms_pelanggan b
ON a.kode_pelanggan = b.kode_pelanggan
JOIN tr_penjualan_detail c
ON a.kode_transaksi = c.kode_transaksi
GROUP BY 1,2,3,4
HAVING COUNT(c.kode_transaksi) > 1
