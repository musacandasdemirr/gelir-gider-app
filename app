import tkinter as tk
from tkinter import messagebox
import pandas as pd

gelir_listesi = []
gider_listesi = []

# Gelir ve giderlerin toplamını güncelleyen fonksiyon
def guncelle_hesaplama():
    toplam_gelir = sum([gelir["Miktar"] for gelir in gelir_listesi]) + (float(gelir_miktari_entry.get()) if gelir_miktari_entry.get() else 0)
    toplam_gider = sum([gider["Miktar"] for gider in gider_listesi]) + (float(gider_miktari_entry.get()) if gider_miktari_entry.get() else 0)
    net_gelir = toplam_gelir - toplam_gider

    sonuc_label.config(
        text=f"Toplam Gelir: {toplam_gelir:.2f} TL\nToplam Gider: {toplam_gider:.2f} TL\nNet Gelir: {net_gelir:.2f} TL"
    )

# Gelir ekleme fonksiyonu
def gelir_ekle():
    try:
        gelir_turu = gelir_turu_entry.get()
        gelir_miktari = float(gelir_miktari_entry.get())
        gelir_listesi.append({"Tür": gelir_turu, "Miktar": gelir_miktari})
        messagebox.showinfo("Başarılı", "Gelir başarıyla eklendi.")
        gelir_turu_entry.delete(0, tk.END)
        gelir_miktari_entry.delete(0, tk.END)
        guncelle_hesaplama()  # Hesaplamayı güncelle
    except ValueError:
        messagebox.showerror("Hata", "Geçerli bir miktar girin.")
        gelir_turu_entry.delete(0, tk.END)
        gelir_miktari_entry.delete(0, tk.END)

# Gider ekleme fonksiyonu
def gider_ekle():
    try:
        gider_turu = gider_turu_entry.get()
        gider_miktari = float(gider_miktari_entry.get())
        gider_listesi.append({"Tür": gider_turu, "Miktar": gider_miktari})
        messagebox.showinfo("Başarılı", "Gider başarıyla eklendi.")
        gider_turu_entry.delete(0, tk.END)
        gider_miktari_entry.delete(0, tk.END)
        guncelle_hesaplama()  # Hesaplamayı güncelle
    except ValueError:
        messagebox.showerror("Hata", "Geçerli bir miktar girin.")
        gider_turu_entry.delete(0, tk.END)
        gider_miktari_entry.delete(0, tk.END)

# Excel dosyasına kaydetme fonksiyonu
def excel_kaydet():
    try:
        if not gelir_listesi and not gider_listesi:
            messagebox.showerror("Hata", "Kaydedilecek veri yok.")
            return

        gelir_df = pd.DataFrame(gelir_listesi)
        gider_df = pd.DataFrame(gider_listesi)

        with pd.ExcelWriter("GelirGider.xlsx", engine="openpyxl") as writer:
            if not gelir_df.empty:
                gelir_df.to_excel(writer, sheet_name="Gelirler", index=False)
            if not gider_df.empty:
                gider_df.to_excel(writer, sheet_name="Giderler", index=False)

        messagebox.showinfo("Başarılı", "Veriler Excel dosyasına başarıyla kaydedildi.")
    except Exception as e:
        messagebox.showerror("Hata", f"Excel kaydedilirken bir hata oluştu: {e}")

# Arayüz
root = tk.Tk()
root.title("Gelir Gider Takip Uygulaması")  # Başlık güncellendi

# Gelir Ekleme
tk.Label(root, text="Gelir Türü (Kira, Maaş, Vb):").grid(row=0, column=0)
gelir_turu_entry = tk.Entry(root)
gelir_turu_entry.grid(row=0, column=1)

tk.Label(root, text="Gelir Miktarı:").grid(row=1, column=0)
gelir_miktari_entry = tk.Entry(root)
gelir_miktari_entry.grid(row=1, column=1)

# Gelir miktarı girişine değişiklikleri dinleyen bir trace ekliyoruz
gelir_miktari_entry.bind("<KeyRelease>", lambda event: guncelle_hesaplama())

tk.Button(root, text="Gelir Ekle", command=gelir_ekle).grid(row=2, column=1)

# Gider Ekleme
tk.Label(root, text="Gider Türü (Fatura, Tahsilat, Vb):").grid(row=3, column=0)
gider_turu_entry = tk.Entry(root)
gider_turu_entry.grid(row=3, column=1)

tk.Label(root, text="Gider Miktarı:").grid(row=4, column=0)
gider_miktari_entry = tk.Entry(root)
gider_miktari_entry.grid(row=4, column=1)

# Gider miktarı girişine değişiklikleri dinleyen bir trace ekliyoruz
gider_miktari_entry.bind("<KeyRelease>", lambda event: guncelle_hesaplama())

tk.Button(root, text="Gider Ekle", command=gider_ekle).grid(row=5, column=1)

# Hesaplama
sonuc_label = tk.Label(root, text="")
sonuc_label.grid(row=7, column=0, columnspan=2)  # Merkezleme için columnspan eklendi

# Excel'e Kaydet
tk.Button(root, text="Excel'e Kaydet", command=excel_kaydet).grid(row=8, column=1)

root.mainloop()  # Uygulamayı başlat