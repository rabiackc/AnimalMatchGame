import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss // Bu görünümü kapatmak için

    var body: some View {
        ZStack {
            Image("arkaplan")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Yeni Hesap Oluştur")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                // TextField genişliği ayarlandı
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .frame(maxWidth: 350) // Maksimum genişlik belirlendi
                
                // SecureField genişliği ayarlandı
                SecureField("Şifre", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(12)
                    .frame(maxWidth: 350) // Maksimum genişlik belirlendi
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 350) // Hata mesajı için de maksimum genişlik
                }
                
                
                Button(action: registerUser) {
                    Text("Kayıt Ol")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 300) // Buton genişliği ayarlandı
                        .background(Color.green)
                        .cornerRadius(15)
                }
            }
            .padding()
            .padding(.horizontal, 20) // VStack'e yatay padding eklendi
            // .navigationTitle("Kayıt Ol") // NavigationStack/View içindeyse kullanılmalı
        }
    }
    
    private func registerUser() {
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .emailAlreadyInUse:
                        errorMessage = "Bu e-posta adresi zaten kullanımda. Lütfen giriş yapın veya farklı bir e-posta kullanın."
                    case .weakPassword:
                        errorMessage = "Şifre çok zayıf. Lütfen en az 6 karakterli bir şifre girin."
                    case .invalidEmail:
                        errorMessage = "Geçersiz e-posta formatı. Lütfen geçerli bir e-posta adresi girin."
                    default:
                        errorMessage = "Kayıt olurken bir hata oluştu: \(error.localizedDescription)"
                    }
                } else {
                    errorMessage = "Kayıt olurken bir hata oluştu: \(error.localizedDescription)"
                }
            } else {
                print("Kullanıcı başarıyla kaydedildi: \(result?.user.email ?? "Bilinmiyor")")
                errorMessage = "Hesabınız başarıyla oluşturuldu. Şimdi giriş yapabilirsiniz!"
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isLoggedIn: .constant(false))
    }
}
