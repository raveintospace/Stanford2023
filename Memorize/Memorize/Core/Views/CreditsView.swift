//
//  CreditsView.swift
//  Memorize
//
//  Created by Uri on 19/4/24.
//

import SwiftUI

struct CreditsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let defaultURL = URL(string: "https://www.google.com")!
    let stanfordURL = URL(string: "https://cs193p.sites.stanford.edu/2023")!
    let linkedinURL = URL(string: "https://www.linkedin.com/in/uri46/")!
    let gitHubURL = URL(string: "https://github.com/raveintospace")!
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    appPurposeSection
                    stanfordSection
                    developerSection
                    appSection
                }
            }
            .font(.headline)
            .tint(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("App info")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    DismissXButton(customAction: nil)
                }
            }
        }
    }
}

#Preview {
    CreditsView()
}

extension CreditsView {
    
    private var appPurposeSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("memorojiAppIcon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("""
                    With this app I followed Stanford University's course CS193p to keep learning how to develop apps with SwiftUI. I have added extra features to make the game more complete.
                    
                    It uses MVVM architecture and has several reusable components.
                    """)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .padding(.vertical)
        } header: {
            Text("App purpose")
        }
    }
    
    private var stanfordSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("stanford")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom, 10)
                Text("You can find more information about Stanford University's course CS193p (Developing Applications for iOS using SwiftUI) clicking on the link below.")
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .padding(.vertical)
            Link("Visit Stanford Course 🏫", destination: stanfordURL)
        } header: {
            Text("Stanford University")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("LinkPic")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom, 10)
                Text("""
                    This is Uri, a junior iOS developer trying to get my first iOS job.

                    I have learned autonomously and by taking courses from some of the most renowned iOS developers, such as Paul Hudson, Swiftful Thinking, Brais Moure or SwiftBeta.
                    """)
                .font(.callout)
                .fontWeight(.medium)
            }
            .padding(.vertical)
            Link("Visit my Linkedin 👨🏻‍💻", destination: linkedinURL)
            Link("Visit my GitHub 🚀", destination: gitHubURL)
        } header: {
            Text("Developer")
        }
    }
    
    private var appSection: some View {
        Section {
            Link("Terms of service", destination: defaultURL)
            Link("Privacy policy", destination: defaultURL)
            Link("Company website", destination: defaultURL)
            Link("Learn more", destination: defaultURL)
        } header: {
            Text("Application")
        }
    }
}
