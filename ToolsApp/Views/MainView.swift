import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            TimerToolView()
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
            // Additional tools can be placed here
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
