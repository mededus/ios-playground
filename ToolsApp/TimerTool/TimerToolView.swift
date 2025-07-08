import SwiftUI

struct TimerToolView: View {
    @StateObject private var viewModel = TimerViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(viewModel.currentPhaseTitle)
                    .font(.title)
                    .padding(.top)
                Text(viewModel.timeString)
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .monospacedDigit()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Focus (min)")
                        Stepper(value: $viewModel.focusMinutes, in: 1...120, step: 1) {
                            Text("\(Int(viewModel.focusMinutes))")
                        }
                    }
                    VStack(alignment: .leading) {
                        Text("Relax (min)")
                        Stepper(value: $viewModel.relaxMinutes, in: 1...120, step: 1) {
                            Text("\(Int(viewModel.relaxMinutes))")
                        }
                    }
                }
                Picker("Sound", selection: $viewModel.selectedSound) {
                    ForEach(TimerSound.allCases) { sound in
                        Text(sound.rawValue).tag(sound)
                    }
                }
                Toggle("Vibration", isOn: $viewModel.vibrationEnabled)
                HStack {
                    Button(action: viewModel.toggleRunning) {
                        Text(viewModel.isRunning ? "Pause" : "Start")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    Button("Reset") {
                        viewModel.reset()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.bordered)
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Focus Timer")
        }
    }
}

struct TimerToolView_Previews: PreviewProvider {
    static var previews: some View {
        TimerToolView()
    }
}
