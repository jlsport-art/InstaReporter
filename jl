import tkinter as tk
from tkinter import filedialog, messagebox, ttk
from PIL import ImageTk, Image
import csv
from datetime import datetime
import time

# Pantalla de bienvenida
def show_welcome():
    splash = tk.Tk()
    splash.title("Bienvenido a InstaReporter")
    splash.geometry("500x300")
    splash.configure(bg="black")
    try:
        img = Image.open("welcome_image.png")
        img = img.resize((500, 300))
        tk_img = ImageTk.PhotoImage(img)
        panel = tk.Label(splash, image=tk_img, bg="black")
        panel.image = tk_img
        panel.pack()
    except:
        tk.Label(splash, text="InstaReporter GUI", fg="white", bg="black", font=("Arial", 24)).pack(expand=True)
    splash.after(3000, splash.destroy)
    splash.mainloop()

# Simulación de ataque
def report_video(video_url, proxy):
    time.sleep(1)
    return "Éxito" if "192.168.0.1" in proxy else "Error de conexión"

# Exportación de resultados
def export_results(results):
    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    default_name = f"resultados_{timestamp}.csv"
    file_path = filedialog.asksaveasfilename(
        initialfile=default_name,
        defaultextension=".csv",
        filetypes=[("Archivo CSV", "*.csv")],
        title="Guardar resultados como"
    )
    if not file_path:
        return
    try:
        with open(file_path, mode='w', newline='', encoding='utf-8') as file:
            writer = csv.writer(file)
            writer.writerow(["Proxy", "Objetivo", "Tipo de ataque", "Resultado"])
            for entry in results:
                writer.writerow(entry)
        messagebox.showinfo("Exportación completada", f"Resultados guardados en:\n{file_path}")
    except Exception as e:
        messagebox.showerror("Error", f"No se pudo guardar el archivo:\n{e}")

# Interfaz principal
def launch_gui():
    root = tk.Tk()
    root.title("InstaReporter GUI")
    root.configure(bg="#1e1e1e")
    root.geometry("600x400")

    proxies = []
    results = []

    def load_proxy_file():
        file_path = filedialog.askopenfilename(filetypes=[("Archivo TXT", "*.txt")])
        if file_path:
            with open(file_path, 'r') as f:
                for line in f:
                    proxy = line.strip()
                    if proxy:
                        proxies.append(proxy)
            messagebox.showinfo("Proxies cargados", f"{len(proxies)} proxies listos.")

    def run_attack():
        url = url_entry.get()
        if not url or not proxies:
            messagebox.showwarning("Faltan datos", "Ingresa una URL y carga proxies.")
            return
        log_box.delete(1.0, tk.END)
        results.clear()
        for proxy in proxies:
            result = report_video(url, proxy)
            log_box.insert(tk.END, f"{proxy} → {result}\n")
            results.append([proxy, url, "Video", result])

    def on_export_click():
        if results:
            export_results(results)
        else:
            messagebox.showwarning("Sin resultados", "Ejecuta el ataque antes de exportar.")

    # Widgets
    tk.Label(root, text="URL del video:", bg="#1e1e1e", fg="white").pack(pady=5)
    url_entry = tk.Entry(root, width=50, bg="#2e2e2e", fg="white", insertbackground="white")
    url_entry.pack(pady=5)

    tk.Button(root, text="Cargar proxies", command=load_proxy_file,
              bg="#00ff88", fg="black", activebackground="#00cc66").pack(pady=5)

    tk.Button(root, text="Ejecutar ataque", command=run_attack,
              bg="#00ff88", fg="black", activebackground="#00cc66").pack(pady=5)

    tk.Button(root, text="Exportar resultados", command=on_export_click,
              bg="#00ff88", fg="black", activebackground="#00cc66").pack(pady=5)

    log_box = tk.Text(root, height=10, width=70, bg="#121212", fg="white")
    log_box.pack(pady=10)

    root.mainloop()

# Ejecución
if __name__ == "__main__":
    show_welcome()
    launch_gui()
