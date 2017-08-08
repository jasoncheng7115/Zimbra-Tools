#!/bin/bash

lower_trigger="10"
higher_trigger="20"
suspected_spam_trigger="100"
from="sendermail@gmail.com"
target="targetmail@gmail.com"
smtp="smtp.gmail.com:587"
tls="yes"
pass="PasswordOfsendermail@gmail.com"
subject="Your subject ex:You have got enemies"
externaldomains=("@externaldomain.com" "@example.com")
internaldomain="@internaldomain.com"

# ============================================================= UNTUK EMAIL YANG ASALNYA DARI LUAR ==================================================
#Pendataan alamat e-mail yang dianggap nyepam (dari luar)

for externaldomain in ${externaldomains[*]}
do
	
	suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f1 | grep "$externaldomain" | sort -u)

	if (suspected_email_from_external_domain != ""){
		suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f2 | grep "$externaldomain" | sort -u)
		if (suspected_email_from_external_domain != ""){
			suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f3 | grep "$externaldomain" | sort -u)
			if (suspected_email_from_external_domain != ""){
				suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f4 | grep "$externaldomain" | sort -u)
				if (suspected_email_from_external_domain != ""){
					suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f5 | grep "$externaldomain" | sort -u)
					if (suspected_email_from_external_domain != ""){
						suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f6 | grep "$externaldomain" | sort -u)
						if (suspected_email_from_external_domain != ""){
							suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f7 | grep "$externaldomain" | sort -u)
							if (suspected_email_from_external_domain != ""){
								suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f8 | grep "$externaldomain" | sort -u)
								if (suspected_email_from_external_domain != ""){
									suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f9 | grep "$externaldomain" | sort -u)
									if (suspected_email_from_external_domain != ""){
										suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f10 | grep "$externaldomain" | sort -u)
										if (suspected_email_from_external_domain != ""){
											suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f11 | grep "$externaldomain" | sort -u)
											if (suspected_email_from_external_domain != ""){
												suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f12 | grep "$externaldomain" | sort -u)
												if (suspected_email_from_external_domain != ""){
													suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f13 | grep "$externaldomain" | sort -u)
													if (suspected_email_from_external_domain != ""){
														suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f14 | grep "$externaldomain" | sort -u)
														if (suspected_email_from_external_domain != ""){
															suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f15 | grep "$externaldomain" | sort -u)
															if (suspected_email_from_external_domain != ""){
																suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f16 | grep "$externaldomain" | sort -u)
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
	}
	
	#Untuk setiap e-mail yang dianggap nyepam (dari luar)
	for i in $suspected_email_from_external_domain
	do
		
		#Tahan semua e-email dari alamat e-mail yang ada di dalam array
		/opt/zimbra/common/sbin/postqueue -p | awk 'BEGIN { RS = "" } { if ($7 == "$i" ) print $1 }' | tr -d '!*' | /opt/zimbra/common/sbin/postsuper -h -

	done
	
done

# ============================================================= UNTUK EMAIL YANG ASALNYA DARI DALAM ==================================================
#Isi dari statistik zimbra
all_count=$(/opt/zimbra/libexec/zmqstat)

#Menghitung e-mail yang tertunda dan aktif di dalam queue
deferred_count=$(/opt/zimbra/libexec/zmqstat | grep "deferred" | sed 's/deferred=//g')
active_count=$(/opt/zimbra/libexec/zmqstat | grep "active" | sed 's/active=//g')

#Jika jumlah e-mail yang tertunda atau aktif di dalam queue > lower_trigger e-mail maka ...
if [ $deferred_count -gt $lower_trigger ] || [ $active_count -gt $lower_trigger ]
then

	#Kirimkan e-mail berisi statistik zimbra (harus menginstall aplikasi sendemail, bukan sendmail)
	sendEmail -f "$from" -t "$target" -s "$smtp" -o tls="$tls" -xu "$from" -xp "$pass" -u "$subject" -m "$all_count"

	#Jika jumlah e-mail yang tertunda atau aktif di dalam queue > higher_trigger e-mail maka ...
	if [ $deferred_count -gt $higher_trigger ] || [ $active_count -gt $higher_trigger ]
	then
		
		#Pendataan alamat e-mail yang dianggap nyepam (dari dalam)
		suspected_email_from_internal_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$internaldomain" | cut -d " " -f1 | grep "$internaldomain" | sort -u)

		if (suspected_email_from_external_domain != ""){
			suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f2 | grep "$externaldomain" | sort -u)
			if (suspected_email_from_external_domain != ""){
				suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f3 | grep "$externaldomain" | sort -u)
				if (suspected_email_from_external_domain != ""){
					suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f4 | grep "$externaldomain" | sort -u)
					if (suspected_email_from_external_domain != ""){
						suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f5 | grep "$externaldomain" | sort -u)
						if (suspected_email_from_external_domain != ""){
							suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f6 | grep "$externaldomain" | sort -u)
							if (suspected_email_from_external_domain != ""){
								suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f7 | grep "$externaldomain" | sort -u)
								if (suspected_email_from_external_domain != ""){
									suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f8 | grep "$externaldomain" | sort -u)
									if (suspected_email_from_external_domain != ""){
										suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f9 | grep "$externaldomain" | sort -u)
										if (suspected_email_from_external_domain != ""){
											suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f10 | grep "$externaldomain" | sort -u)
											if (suspected_email_from_external_domain != ""){
												suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f11 | grep "$externaldomain" | sort -u)
												if (suspected_email_from_external_domain != ""){
													suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f12 | grep "$externaldomain" | sort -u)
													if (suspected_email_from_external_domain != ""){
														suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f13 | grep "$externaldomain" | sort -u)
														if (suspected_email_from_external_domain != ""){
															suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f14 | grep "$externaldomain" | sort -u)
															if (suspected_email_from_external_domain != ""){
																suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f15 | grep "$externaldomain" | sort -u)
																if (suspected_email_from_external_domain != ""){
																	suspected_email_from_external_domain=$(/opt/zimbra/common/sbin/postqueue -p | grep "$externaldomain" | cut -d " " -f16 | grep "$externaldomain" | sort -u)
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		
		#Untuk setiap e-mail yang dianggap nyepam (dari dalam)
		for i in $suspected_email_from_internal_domain
		do
			
			#Dihitung jumlah e-mailnya
			suspected_spam_count=$(/opt/zimbra/common/sbin/postqueue -p | grep "$i" | wc -l)
			
			#Jika jumlah email dari alamat yang dianggap nyepam > suspected_spam_trigger maka ...
			if [ $suspected_spam_count -gt $suspected_spam_trigger ]
			then
			
				#Buat password baru
				new_password=$(od -vAn -N4 -tu4 < /dev/urandom)
				
				#Ganti password dengan password yang baru
				/opt/zimbra/bin/zmprov sp "$i" "$new_password"
				
				#Tahan semua e-email dari alamat e-mail yang terindikasi sebagai spammer
				/opt/zimbra/common/sbin/postqueue -p | awk 'BEGIN { RS = "" } { if ($7 == "$i" ) print $1 }' | tr -d '!*' | /opt/zimbra/common/sbin/postsuper -h -
			fi

		done

	fi

fi
