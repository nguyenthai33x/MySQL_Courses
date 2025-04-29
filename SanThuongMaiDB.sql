Create database SanThuongMai;
use SanThuongMai;

-- 1. Người dùng & Quản trị
CREATE TABLE nguoi_dung (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_dang_nhap VARCHAR(50) NOT NULL UNIQUE,
    mat_khau VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    so_dien_thoai VARCHAR(20),
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    trang_thai TINYINT DEFAULT 1
);

CREATE TABLE vai_tro (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_vai_tro VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE nguoi_dung_vai_tro (
    id_nguoi_dung INT,
    id_vai_tro INT,
    PRIMARY KEY (id_nguoi_dung, id_vai_tro),
    FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id),
    FOREIGN KEY (id_vai_tro) REFERENCES vai_tro(id)
);

CREATE TABLE quan_tri (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_nguoi_dung INT UNIQUE,
    mo_ta TEXT,
    FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id)
);

-- 2. Sản phẩm & Danh mục
CREATE TABLE thuong_hieu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_thuong_hieu VARCHAR(100),
    mo_ta TEXT
);

CREATE TABLE nha_cung_cap (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_nha_cung_cap VARCHAR(100),
    dia_chi TEXT,
    so_dien_thoai VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE san_pham (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_san_pham VARCHAR(255),
    mo_ta TEXT,
    gia DECIMAL(15,2),
    so_luong INT,
    id_thuong_hieu INT,
    id_nha_cung_cap INT,
    ngay_tao DATETIME DEFAULT CURRENT_TIMESTAMP,
    trang_thai TINYINT DEFAULT 1,
    FOREIGN KEY (id_thuong_hieu) REFERENCES thuong_hieu(id),
    FOREIGN KEY (id_nha_cung_cap) REFERENCES nha_cung_cap(id)
);

CREATE TABLE danh_muc (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_danh_muc VARCHAR(100),
    mo_ta TEXT
);

CREATE TABLE san_pham_danh_muc (
    id_san_pham INT,
    id_danh_muc INT,
    PRIMARY KEY (id_san_pham, id_danh_muc),
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id),
    FOREIGN KEY (id_danh_muc) REFERENCES danh_muc(id)
);

-- 3. Đơn hàng
CREATE TABLE phuong_thuc_van_chuyen (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_phuong_thuc VARCHAR(100),
    phi DECIMAL(10,2)
);

CREATE TABLE thanh_toan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    phuong_thuc VARCHAR(100),
    trang_thai VARCHAR(50),
    ngay_thanh_toan DATETIME
);

CREATE TABLE van_chuyen (
    id INT PRIMARY KEY AUTO_INCREMENT,
    phuong_thuc VARCHAR(100),
    trang_thai VARCHAR(50),
    ngay_van_chuyen DATETIME,
    ma_van_don VARCHAR(100)
);

CREATE TABLE don_hang (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_khach_hang INT,
    ngay_dat DATETIME DEFAULT CURRENT_TIMESTAMP,
    tong_tien DECIMAL(15,2),
    trang_thai VARCHAR(50),
    id_thanh_toan INT,
    id_van_chuyen INT,
    FOREIGN KEY (id_thanh_toan) REFERENCES thanh_toan(id),
    FOREIGN KEY (id_van_chuyen) REFERENCES van_chuyen(id)
);

CREATE TABLE chi_tiet_don_hang (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_don_hang INT,
    id_san_pham INT,
    so_luong INT,
    don_gia DECIMAL(15,2),
    FOREIGN KEY (id_don_hang) REFERENCES don_hang(id),
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id)
);

-- 4. Khuyến mãi & Mã giảm giá
CREATE TABLE khuyen_mai (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_khuyen_mai VARCHAR(100),
    mo_ta TEXT,
    loai VARCHAR(50),
    gia_tri DECIMAL(10,2),
    ngay_bat_dau DATE,
    ngay_ket_thuc DATE,
    trang_thai TINYINT DEFAULT 1
);

CREATE TABLE ma_giam_gia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ma VARCHAR(50) UNIQUE,
    mo_ta TEXT,
    gia_tri DECIMAL(10,2),
    loai VARCHAR(50),
    so_lan_su_dung INT,
    ngay_het_han DATE,
    trang_thai TINYINT DEFAULT 1
);

CREATE TABLE khuyen_mai_san_pham (
    id_khuyen_mai INT,
    id_san_pham INT,
    PRIMARY KEY (id_khuyen_mai, id_san_pham),
    FOREIGN KEY (id_khuyen_mai) REFERENCES khuyen_mai(id),
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id)
);

-- 5. Đánh giá & Hỏi đáp
CREATE TABLE danh_gia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_san_pham INT,
    id_khach_hang INT,
    so_sao INT,
    noi_dung TEXT,
    ngay_danh_gia DATETIME,
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id)
);

CREATE TABLE cau_hoi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_san_pham INT,
    id_khach_hang INT,
    noi_dung TEXT,
    ngay_dat DATETIME,
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id)
);

CREATE TABLE tra_loi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_cau_hoi INT,
    id_nguoi_dung INT,
    noi_dung TEXT,
    ngay_tra_loi DATETIME,
    FOREIGN KEY (id_cau_hoi) REFERENCES cau_hoi(id),
    FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id)
);

-- 6. Kho hàng
CREATE TABLE kho (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ten_kho VARCHAR(100),
    dia_chi TEXT
);

CREATE TABLE ton_kho (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_san_pham INT,
    id_kho INT,
    so_luong_hien_tai INT,
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id),
    FOREIGN KEY (id_kho) REFERENCES kho(id)
);

CREATE TABLE lich_su_nhap_xuat (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_san_pham INT,
    id_kho INT,
    loai VARCHAR(50), -- Nhap/Xuat
    so_luong INT,
    ngay_thuc_hien DATETIME,
    ghi_chu TEXT,
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id),
    FOREIGN KEY (id_kho) REFERENCES kho(id)
);

-- 7. Giao dịch & Lịch sử
CREATE TABLE giao_dich (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_don_hang INT,
    loai_giao_dich VARCHAR(50),
    so_tien DECIMAL(15,2),
    ngay_giao_dich DATETIME,
    mo_ta TEXT,
    FOREIGN KEY (id_don_hang) REFERENCES don_hang(id)
);

CREATE TABLE nhat_ky_he_thong (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_nguoi_dung INT,
    hanh_dong VARCHAR(100),
    ngay_thuc_hien DATETIME,
    mo_ta TEXT,
    FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id)
);

CREATE TABLE nhat_ky_hoat_dong (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_nguoi_dung INT,
    loai_hoat_dong VARCHAR(100),
    noi_dung TEXT,
    ngay DATETIME,
    FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id)
);

-- 8. Khách hàng & Danh sách yêu thích
CREATE TABLE khach_hang (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_nguoi_dung INT UNIQUE,
    dia_chi TEXT,
    ngay_dang_ky DATETIME,
    trang_thai TINYINT DEFAULT 1,
    FOREIGN KEY (id_nguoi_dung) REFERENCES nguoi_dung(id)
);

CREATE TABLE yeu_thich (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_khach_hang INT,
    ten_danh_sach VARCHAR(100),
    FOREIGN KEY (id_khach_hang) REFERENCES khach_hang(id)
);

CREATE TABLE yeu_thich_san_pham (
    id_yeu_thich INT,
    id_san_pham INT,
    PRIMARY KEY (id_yeu_thich, id_san_pham),
    FOREIGN KEY (id_yeu_thich) REFERENCES yeu_thich(id),
    FOREIGN KEY (id_san_pham) REFERENCES san_pham(id)
);

-- 9. Hỗ trợ & Liên hệ
CREATE TABLE ho_tro (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_khach_hang INT,
    tieu_de VARCHAR(200),
    mo_ta TEXT,
    trang_thai VARCHAR(50),
    ngay_gui DATETIME,
    FOREIGN KEY (id_khach_hang) REFERENCES khach_hang(id)
);

CREATE TABLE tin_nhan_ho_tro (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_ho_tro INT,
    id_nguoi_gui INT,
    noi_dung TEXT,
    ngay_gui DATETIME,
    FOREIGN KEY (id_ho_tro) REFERENCES ho_tro(id),
    FOREIGN KEY (id_nguoi_gui) REFERENCES nguoi_dung(id)
);
