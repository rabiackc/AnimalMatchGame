import SwiftUI
import FirebaseAuth
import Combine

// Kartın veri modeli
struct Card: Identifiable {
    let id = UUID()
    let name: String
    var isFlipped: Bool = false
    var isMatched: Bool = false
}

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    
    // Oyunla ilgili tüm durum değişkenleri
    @State private var cards: [Card] = []
    @State private var flippedCards: [Card] = []
    @State private var matchedCardsCount = 0
    @State private var score = 0
    @State private var gameStarted = false
    @State private var isGameOver = false
    
    @State private var timeRemaining = 60
    @State private var timerPublisher = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var cancellable: AnyCancellable?
    
    private let cardImageNames = ["bear", "fox", "rabbit", "lion", "elephant", "giraffe"]
    
    var body: some View {
        if isLoggedIn {
            // MARK: - Oyun Ekranı
            NavigationStack {
                ZStack {
                   
                    Color.gray.opacity(0.2).ignoresSafeArea() // Hafif gri ve şeffaf bir arka plan
                  

                    VStack(spacing: 20) {
                        HStack {
                            Text("Skor: \(score)")
                                .font(.title).bold()
                                .foregroundColor(.white)
                            Spacer()
                            Text("Süre: \(timeRemaining)s")
                                .font(.title).bold()
                                .foregroundColor(.white)
                            Spacer()
                            Button("Çıkış Yap") {
                                signOut()
                            }
                            .buttonStyle(.borderedProminent).tint(.red)
                        }
                        .padding()
                        
                        if !gameStarted {
                            Button("Oyunu Başlat") {
                                setupGame()
                                gameStarted = true
                                isGameOver = false
                            }
                            .buttonStyle(.borderedProminent)
                            .padding()
                            .tint(.green)
                            
                        } else if isGameOver {
                            GameOverView(score: score) {
                                gameStarted = false
                                isGameOver = false
                            }
                        } else {
                            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 80)), count: 4)) {
                                ForEach(cards.indices, id: \.self) { index in
                                    CardView(card: $cards[index])
                                        .onTapGesture {
                                            flipCard(at: index)
                                        }
                                }
                            }
                            .padding()
                        }
                        
                        Spacer()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Animal Match")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .onReceive(timerPublisher) { _ in
                    guard gameStarted && !isGameOver else {
                        self.cancellable?.cancel()
                        return
                    }
                    
                    if timeRemaining > 0 {
                        timeRemaining -= 1
                    } else {
                        endGame()
                    }
                }
                .onAppear {
                    cancellable?.cancel()
                }
            }
        } else {
            // MARK: - Giriş ve Kayıt Ekranı 
            NavigationStack {
                ZStack {
                    Image("arkaplan")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .opacity(0.8)
                    
                    Color.black.opacity(0.3).ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        Text("🐻 Animal Match 🦊")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        // TextField ve SecureField
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(12)
                            .frame(maxWidth: 350) // Maksimum genişlik
                        
                        SecureField("Şifre", text: $password)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(12)
                            .frame(maxWidth: 350)
                        
                        if !errorMessage.isEmpty {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 350)
                        }
                        
                        Button(action: signIn) {
                            Text("🎮 Giriş Yap")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 300) // Buton genişliği
                                .background(Color.pink)
                                .cornerRadius(15)
                        }
                        
                        NavigationLink(destination: RegisterView(isLoggedIn: $isLoggedIn)) {
                            Text("📝 Kayıt Ol")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 300)
                                .background(Color.purple)
                                .cornerRadius(15)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20) // VStack'e yatay padding
                }
            }
        }
    }
    
    // MARK: - Firebase Yardımcı Fonksiyonları
    
    private func signIn() {
        errorMessage = ""
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                errorMessage = "Giriş Hatası: \(error.localizedDescription)"
            } else {
                isLoggedIn = true
            }
        }
    }
    
    private func signOut() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch {
            print("Çıkış yapma hatası: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Oyun Mantığı Fonksiyonları
    
    private func setupGame() {
        timeRemaining = 60
        cancellable?.cancel()
        cancellable = timerPublisher.sink { _ in }
        
        flippedCards = []
        matchedCardsCount = 0
        score = 0
        isGameOver = false
        
        var gameCardContents: [String] = []
        for _ in 0..<2 {
            gameCardContents.append(contentsOf: cardImageNames)
        }
        gameCardContents.shuffle()
        
        cards = gameCardContents.map { name in
            Card(name: name, isFlipped: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for i in cards.indices {
                cards[i].isFlipped = false
            }
        }
    }
    
    private func flipCard(at index: Int) {
        if isGameOver || cards[index].isFlipped || cards[index].isMatched || flippedCards.count == 2 {
            return
        }
        
        cards[index].isFlipped = true
        flippedCards.append(cards[index])
        
        if flippedCards.count == 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                checkMatch()
            }
        }
    }
    
    private func checkMatch() {
        if flippedCards[0].name == flippedCards[1].name {
            for i in cards.indices {
                if cards[i].id == flippedCards[0].id || cards[i].id == flippedCards[1].id {
                    cards[i].isMatched = true
                    cards[i].isFlipped = true
                }
            }
            score += 10
            matchedCardsCount += 2
            
            if matchedCardsCount == cards.count {
                endGame()
            }
        } else {
            for i in cards.indices {
                if cards[i].id == flippedCards[0].id || cards[i].id == flippedCards[1].id {
                    cards[i].isFlipped = false
                }
            }
        }
        flippedCards.removeAll()
    }
    
    private func endGame() {
        cancellable?.cancel()
        isGameOver = true
    }
}

// MARK: - Yardımcı Görünümler

struct CardView: View {
    @Binding var card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(card.isMatched ? Color.clear : Color.white)
                .shadow(radius: 5)
            
            if card.isFlipped {
                Image(card.name)
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                    .transition(.scale)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.purple)
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
}

struct GameOverView: View {
    let score: Int
    let onRestart: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Oyun Bitti!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("Son Skorunuz: \(score)")
                .font(.title2)
                .foregroundColor(.black)
            
            Button(action: onRestart) {
                Text("Tekrar Oyna")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding(40)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

// MARK: - Önizleme Sağlayıcı

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
