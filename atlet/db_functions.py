from django.db import connection

# def get_enrolled_partai_kompetisi_event():

def get_all_atlet_data():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
        SELECT * FROM ATLET
        """)
        rows = cursor.fetchall()
    return rows

def get_all_sponsor_data():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
        SELECT * FROM SPONSOR
        """)
        rows = cursor.fetchall()
    return rows


def unenrolled_event():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
        DELETE FROM PESERTA_MENDAFTAR_EVENT
        WHERE Nama_Event = 'China Open'
        AND Tahun = 2020
        AND Nomor_Peserta IN (
            SELECT PK.Nomor_Peserta
            FROM PESERTA_KOMPETISI PK
            JOIN ATLET A ON A.ID = PK.ID_Atlet_Kualifikasi
            WHERE A.ID = 'e2cde9d3-205f-4e6d-9e7a-1b5a53b72c8a'
        );
        """)
        rows = cursor.fetchall()
    return rows
    

def submit_daftar_sponsor():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
        INSERT INTO ATLET_SPONSOR (ID_Atlet, ID_Sponsor, Tgl_Mulai, Tgl_Selesai)
        VALUES ('89216d3c-2829-4512-a49e-5db03d105a4b', 'bde8242f-b5ff-4b8c-87e3-13006fe00aa5', CURRENT_DATE, '2023-05-24');
        """)
        rows = cursor.fetchall()
    return rows

def get_all_atlet_sponsor_data():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
        SELECT * FROM ATLET_SPONSOR
        """)
        rows = cursor.fetchall()
    return rows

def get_all_partai_peserta_kompetisi():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
        SELECT PPK.Jenis_Partai, PPK.Nama_Event, PPK.Tahun_Event, E.Nama_Stadium, E.Kategori_Superseries, E.Tgl_Mulai, E.Tgl_Selesai
        FROM PARTAI_PESERTA_KOMPETISI PPK
        JOIN EVENT E ON PPK.Nama_Event = E.Nama_Event;
        """)
        rows = cursor.fetchall()
    return rows

def get_enrolled_event():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
        SELECT E.Nama_Event AS "Event Name", E.Tahun AS "Year", E.Nama_Stadium AS "Stadium",
        E.Kategori_Superseries AS "Superseries Category", E.Tgl_Mulai AS "Start Date",
        E.Tgl_Selesai AS "End Date"
        FROM EVENT E
        JOIN PESERTA_MENDAFTAR_EVENT PME ON PME.Nama_Event = E.Nama_Event AND PME.Tahun = E.Tahun
        JOIN PESERTA_KOMPETISI PK ON PK.Nomor_Peserta = PME.Nomor_Peserta
        JOIN ATLET A ON A.ID = PK.ID_Atlet_Kualifikasi
        WHERE A.ID = 'e2cde9d3-205f-4e6d-9e7a-1b5a53b72c8a';
        """)
        rows = cursor.fetchall()
    return rows