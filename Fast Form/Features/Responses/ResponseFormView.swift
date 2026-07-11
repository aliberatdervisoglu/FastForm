
import SwiftUI

struct ResponseFormView: View {
    @State var viewModel = ResponseFormViewViewModel()
    @State private var localSearchError: String? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {
                        if viewModel.searchText.isEmpty {
                            welcomeSection
                                .padding(.top, 40)
                        } else if viewModel.searchText.count > 0, viewModel.searchText.count < 3 {
                            ContentUnavailableView(
                                "Keep typing...",
                                systemImage: "text.cursor",
                                description: Text("Please enter at least 3 characters to search for a form.")
                            )
                            .padding(.top, 40)
                        } else if viewModel.isLoading {
                            ProgressView("Searching forms...")
                                .padding(.top, 40)
                        } else if let errorMessage = localSearchError {
                            ContentUnavailableView(
                                "Search Error",
                                systemImage: "wifi.exclamationmark",
                                description: Text(errorMessage)
                            )
                            .padding(.top, 40)

                        } else if viewModel.results.isEmpty, viewModel.isLoading == false {
                            ContentUnavailableView.search(text: viewModel.searchText)
                                .padding(.top, 40)
                        } else {
                            ForEach(viewModel.results) { form in
                                NavigationLink(destination: ResponseChoosenFormView(form: form)) {
                                    formSearchResultCard(for: form)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Find Form")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter a Form Title...")
            .onChange(of: viewModel.searchText) { _, _ in
                Task {
                    localSearchError = nil
                    do {
                        try await viewModel.searchForms()
                    } catch {
                        localSearchError = error.localizedDescription
                    }
                }
            }
        }
    }

    private var welcomeSection: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(LinearGradient.brandGradient)

            Text("Ready to fill out a form?")
                .font(.title2)
                .fontWeight(.bold)

            Text("Enter a form title in the search bar above to find it and share your answers.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .padding()
    }

    private func formSearchResultCard(for form: FormModel) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(form.title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(form.explanation)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "doc.text.below.ecg.fill")
                .font(.title2)
                .foregroundStyle(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(LinearGradient.brandGradient)
        )
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ResponseFormView()
}
