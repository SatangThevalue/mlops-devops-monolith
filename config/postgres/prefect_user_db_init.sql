-- prefect_user_db_init.sql

-- 1. สร้าง Role/User สำหรับ Prefect
-- ใช้คำสั่ง DO/BEGIN/END เพื่อจัดการการตรวจสอบเงื่อนไขว่า User มีอยู่แล้วหรือไม่
DO
\$body\$
BEGIN
    IF NOT EXISTS (
        SELECT
        FROM   pg_catalog.pg_user
        WHERE  usename = 'prefect_app_user') THEN

        -- สร้าง User และกำหนดรหัสผ่านตาม ENV
        CREATE ROLE prefect_app_user WITH LOGIN PASSWORD '1234567890';
        
        -- ให้สิทธิ์ในการสร้างฐานข้อมูล (จำเป็นสำหรับ Prefect Server)
        ALTER ROLE prefect_app_user CREATEDB;
        RAISE NOTICE 'Prefect user prefect_app_user created.';
    ELSE
        RAISE NOTICE 'Prefect user prefect_app_user already exists.';
    END IF;
END
\$body\$;

-- 2. สร้างฐานข้อมูลสำหรับ Prefect
-- ใช้ SELECT ... WHERE NOT EXISTS และ \gexec เพื่อรัน CREATE DATABASE แบบมีเงื่อนไข
SELECT 'CREATE DATABASE prefect_db OWNER prefect_app_user'
WHERE NOT EXISTS (
    SELECT 1 FROM pg_database WHERE datname = 'prefect_db'
)\gexec

RAISE NOTICE 'Prefect database prefect_db ensured.';