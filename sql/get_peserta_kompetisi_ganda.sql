
	SELECT G.id_atlet_kualifikasi, G.id_atlet_kualifikasi_2 FROM BADUDU.PESERTA_KOMPETISI P
		join badudu.ATLET_GANDA G on P.id_atlet_ganda=G.id_atlet_ganda
		WHERE nomor_peserta in
			(
				SELECT nomor_peserta FROM badudu.peserta_mendaftar_event
            	WHERE nama_event = 'China Open');
	