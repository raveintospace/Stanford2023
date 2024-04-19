//
//  CreditsView.swift
//  Memorize
//
//  Created by Uri on 19/4/24.
//

import SwiftUI

struct CreditsView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGameViewModel
    
    @Environment(\.dismiss) var dismiss
    
    let defaultURL = URL(string: "https://www.google.com")!
    let opendatasoftURL = URL(string: "https://public.opendatasoft.com/")!
    let airbnbDataSetURL = URL(string: "https://public.opendatasoft.com/explore/dataset/airbnb-listings/api/?disjunctive.host_verifications&disjunctive.amenities&disjunctive.features")!
    let linkedinURL = URL(string: "https://www.linkedin.com/in/uri46/")!
    let gitHubURL = URL(string: "https://github.com/raveintospace")!
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    appPurposeSection
                    openDatasoftSection
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
    CreditsView(viewModel: EmojiMemoryGameViewModel())
}

extension CreditsView {
    
    private var appPurposeSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("customlogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("""
                    With this app I want to show my skills as an iOS developer. I have practiced some learnings from previous programs, but I have also acquired a lot of knowledge, facing challenges, a few dead end situations and refactor sessions.

                    It uses MVVM architechture, Combine & CoreData.
                    """)
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .padding(.vertical)
        } header: {
            Text("App purpose")
        }
    }
    
    private var openDatasoftSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("ods")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom, 10)
                Text("The Airbnb data used in this app comes from a free Opendata's API. JSON content may vary or come incomplete.")
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .padding(.vertical)
            Link("Visit Opendatasoft 🖥️", destination: opendatasoftURL)
            Link("Visit Airbnb dataset 🏠", destination: airbnbDataSetURL)
        } header: {
            Text("Opendatasoft")
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
