//
//  SwiftUIView.swift
//  Gitlab
//
//  Created by a-pavlov on 23.04.22.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    @Environment(\.locale) private var locale: Locale
    let inspection = Inspection<Self>()
    
    var body: some View {
        self.content
    }
    
    private var content: AnyView {
        switch viewModel.user {
        case .notRequested: return AnyView(notRequestedView)
        case let .isLoading(last, _): return AnyView(loadingView(last))
        case let .loaded(user): return AnyView(loadedView(user, showLoading: false))
        case let .failed(error): return AnyView(failedView(error))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: .init(container: .preview))
            .preferredColorScheme(.dark)
    }
}

// MARK: - Loading Content

private extension ProfileView {
    var notRequestedView: some View {
        Text("").onAppear(perform: self.viewModel.reloadUser)
    }
    
    func loadingView(_ previouslyLoaded: UserModel?) -> some View {
        if let user = previouslyLoaded {
            return AnyView(loadedView(user, showLoading: true))
        } else {
            return AnyView(ActivityIndicatorView().padding())
        }
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            self.viewModel.reloadUser()
        })
    }
}

// MARK: - Displaying Content

private extension ProfileView {
    func loadedView(_ user: UserModel, showLoading: Bool) -> some View {
        VStack {
            if showLoading {
                ActivityIndicatorView().padding()
            }
            ScrollView {
                HStack {
                    AsyncImage(url: user.avatar_url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 70, height: 70).cornerRadius(35)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Work at Bali").font(.subheadline)
                        Text(user.username).font(.caption)
                    }
                }
                
                HStack(alignment: .center) {
                    Image(systemName: "person").foregroundColor(Color.gray)
                    Text("2").foregroundColor(Color.white)
                    Text("followers").font(.footnote).foregroundColor(Color.gray).frame(alignment: .bottom)
                    Rectangle().frame(width: 2, height: 2, alignment: .center).foregroundColor(.white).cornerRadius(1)
                    Text("2").foregroundColor(Color.white)
                    Text("following").font(.footnote).foregroundColor(Color.gray)
                }
            }.frame(maxWidth: .infinity, alignment: .center).background(Color(UIColor(named: "background_1")!))
        }
    }
}
