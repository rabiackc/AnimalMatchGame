# AnimalMatchGame

<p align="center">
  <img src="screenshots/Ekran Resmi 2025-07-28 14.06.27.jpg" alt="Oyun Ekranı" width="350"/>
  <img src="screenshots/Ekran Resmi 2025-07-28 14.05.13.jpg" alt="Giriş Ekranı" width="350"/>
  <br>
  <em>Uygulamanın ana oyun ekranı (solda) ve giriş/kayıt ekranı (sağda).</em>
  <img src="screenshots/ekrankaydı.gif" alt="Uygulama Demosu" width="450"/>
</p>
</p>

## 🚀 Proje Açıklaması

Animal Match Game, kullanıcıların hafızalarını test edebilecekleri eğlenceli ve etkileşimli bir hayvan eşleştirme oyunudur. Firebase kimlik doğrulama entegrasyonu sayesinde kullanıcılar kayıt olabilir, giriş yapabilir ve kişiselleştirilmiş bir oyun deneyimi yaşayabilirler. Oyun, kullanıcıların aynı hayvan çiftlerini bulmasını gerektiren klasik bir hafıza oyunudur.

## ✨ Özellikler

* **Kullanıcı Kimlik Doğrulama:**
    * E-posta ve şifre ile yeni hesap oluşturma.
    * Mevcut kullanıcılar için güvenli giriş yapma.
    * Firebase Authentication ile hata yönetimi ve kullanıcı geri bildirimi.
* **Hafıza Oyunu:**
    * Çeşitli sevimli hayvan kartları ile eşleştirme.
    * Geri sayım sayacı ile zaman kısıtlaması.
    * Eşleşen kartlar için puanlama sistemi.
    * Oyun bitiş ekranı ve yeniden başlama seçeneği.
* **Kullanıcı Dostu Arayüz:**
    * Modern ve sezgisel SwiftUI arayüzü.
    * Görsel olarak çekici arka planlar ve animasyonlar.

## 🛠️ Kullanılan Teknolojiler

* **SwiftUI:** Kullanıcı arayüzü geliştirme için deklaratif çerçeve.
* **Firebase Authentication:** Kullanıcı kayıt ve giriş işlemleri için backend hizmeti.
* **Combine:** Zamanlayıcı ve asenkron olay yönetimi için reaktif çerçeve.
* **Swift:** iOS uygulama geliştirme dili.

## ⚙️ Kurulum ve Çalıştırma

Bu projeyi yerel ortamınızda kurmak ve çalıştırmak için aşağıdaki adımları izleyin:

### Ön Gereksinimler

* macOS işletim sistemi
* Xcode 13.0 veya üzeri
* CocoaPods veya Swift Package Manager (SPM) (Firebase kurulumu için)
* Aktif bir Firebase projesi

### Adımlar

1.  **Projeyi Klonlayın:**
    ```bash
    git clone [https://github.com/KULLANICI_ADINIZ/AnimalMatchGame.git](https://github.com/KULLANICI_ADINIZ/AnimalMatchGame.git)
    cd AnimalMatchGame
    ```
    *(`rabiackc.)*

2.  **Firebase Kurulumu:**
    * [Firebase Konsolu](https://console.firebase.google.com/) üzerinden yeni bir Firebase projesi oluşturun.
    * Projenize bir iOS uygulaması ekleyin.
    * Uygulamanız için `GoogleService-Info.plist` dosyasını indirin ve Xcode projenizin kök dizinine sürükleyip bırakın (Hedeflere eklediğinizden emin olun).
    * Firebase Authentication'da "Email/Password" oturum açma yöntemini etkinleştirin.
    * **Swift Package Manager (SPM) kullanıyorsanız:**
        * Xcode'da `File > Add Packages...` seçeneğini seçin.
        * Firebase Swift SDK URL'sini yapıştırın: `https://github.com/firebase/firebase-ios-sdk.git`
        * `Firebase/Auth` paketini seçin ve projenize ekleyin.
    * **CocoaPods kullanıyorsanız:**
        * Terminali açın, proje dizininize gidin.
        * `pod init` komutunu çalıştırın.
        * `Podfile` dosyasını açın ve aşağıdaki satırı ekleyin:
            ```ruby
            pod 'Firebase/Auth'
            ```
        * `pod install` komutunu çalıştırın.
        * `.xcworkspace` uzantılı dosyayı kullanarak projenizi açın.

3.  **Gerekli Resim Dosyalarını Ekleyin:**
    * `bear`, `fox`, `rabbit`, `lion`, `elephant`, `giraffe` adlarında hayvan resimlerini ve `arkaplan` adlı arka plan resmini projenizin `Assets.xcassets` klasörüne ekleyin. Bu resimler uygulamanın doğru şekilde çalışması için gereklidir.

4.  **Xcode'da Çalıştırın:**
    * Xcode'u açın.
    * Bir simülatör veya gerçek bir cihaz seçin.
    * Uygulamayı çalıştırmak için "Build and Run" düğmesine (oynat düğmesi) tıklayın.

## 💡 Kullanım

1.  Uygulamayı başlattığınızda karşınıza **Giriş / Kayıt** ekranı gelecektir.
2.  Yeni bir kullanıcıysanız, **"Kayıt Ol"** butonuna tıklayarak e-posta ve şifrenizle bir hesap oluşturun.
3.  Hesabınızı oluşturduktan sonra veya zaten bir hesabınız varsa, **Giriş Yap** ekranına geri dönerek e-posta ve şifrenizle giriş yapın.
4.  Başarılı girişin ardından oyun ekranına yönlendirileceksiniz.
5.  **"Oyunu Başlat"** butonuna tıklayarak hafıza oyununu oynamaya başlayın. Kartları çevirerek aynı hayvan çiftlerini bulun ve puan kazanın!

## 🤝 Katkıda Bulunma

Projenin geliştirilmesine katkıda bulunmaktan çekinmeyin! Her türlü katkı (hata düzeltmeleri, yeni özellikler, dokümantasyon iyileştirmeleri vb.) memnuniyetle karşılanır.

1.  Projeyi forklayın.
2.  Yeni bir dal (`git checkout -b feature/AmazingFeature`) oluşturun.
3.  Değişikliklerinizi yapın.
4.  Değişikliklerinizi commit edin (`git commit -m 'Add some AmazingFeature'`).
5.  Dalı push edin (`git push origin feature/AmazingFeature`).
6.  Bir Pull Request açın.

## 📄 Lisans

Bu proje, MIT Lisansı altında yayınlanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakın..
