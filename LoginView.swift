import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    @Binding var isLoggedIn: Bool
    @Environment(\.dismiss) var dismiss

    @State private var showingRegisterSheet = false

    var body: some View {
        ZStack {
            Image("arkaplan")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            Color.black.opacity(0.3).ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Giriş Yap")
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

                // Buton genişliği ayarlandı
                Button(action: loginUser) {
                    Text("Giriş Yap")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 300)  
                        .background(Color.blue)
                        .cornerRadius(15)
                }

                Button(action: {
                    showingRegisterSheet = true
                }) {
                    Text("Hesabın yok mu? Kayıt ol")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .padding()
            .padding(.horizontal, 20) // VStack'e yatay padding eklendi
            
            .sheet(isPresented: $showingRegisterSheet) {
                RegisterView(isLoggedIn: $isLoggedIn)
            }
        }
    }

    private func loginUser() {
        errorMessage = ""

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                if let errCode = AuthErrorCode(rawValue: error._code) {
                    switch errCode {
                    case .userNotFound:
                        errorMessage = "Bu e-posta adresine kayıtlı bir kullanıcı bulunamadı."
                    case .wrongPassword:
                        errorMessage = "Yanlış şifre. Lütfen tekrar deneyin."
                    case .invalidEmail:
                        errorMessage = "Geçersiz e-posta formatı. Lütfen geçerli bir e-posta adresi girin."
                    case .userDisabled:
                        errorMessage = "Hesabınız devre dışı bırakılmış. Lütfen yöneticiyle iletişime geçin."
                    default:
                        errorMessage = "Giriş yaparken bir hata oluştu: \(error.localizedDescription)"
                    }
                } else {
                    errorMessage = "Giriş yaparken bir hata oluştu: \(error.localizedDescription)"
                }
            } else {
                print("Kullanıcı başarıyla giriş yaptı: \(result?.user.email ?? "Bilinmiyor")")
                isLoggedIn = true
                dismiss()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isLoggedIn: .constant(false))
    }
}
