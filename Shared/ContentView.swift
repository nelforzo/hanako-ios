//
//  ContentView.swift
//  Shared
//
//  Created by Frank Lopez on 2022/01/01.
//

import SwiftUI
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct ContentView: View {
    var body: some View {
        Text("keeping your stuff in order!")
            .padding()
        
        Button {
            CreateUser()
        } label: {
            Text("new user").padding(8.0)
        }.overlay(RoundedRectangle(cornerRadius: 4.0).stroke(lineWidth: 2.0))
        
        Button {
            print("login")
        } label: {
            Text("login").padding(8.0)
        }.overlay(RoundedRectangle(cornerRadius: 4.0).stroke(lineWidth: 2.0))

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func CreateUser() {
    var semaphore = DispatchSemaphore (value: 0)

    let parameters = "{\n    \"first_name\":\"frank\",\n    \"last_name\":\"lopez\",\n    \"first_name_kana\":\"フランク\",\n    \"last_name_kana\":\"ロペス\",\n    \"mail_address\":\"spiccanelforzo@outlook.com\",\n    \"password\":\"Admin123\",\n    \"password_confirmation\":\"Admin123\"\n}"
    let postData = parameters.data(using: .utf8)

    var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/users")!,timeoutInterval: Double.infinity)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    request.httpMethod = "POST"
    request.httpBody = postData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data else {
        print(String(describing: error))
        semaphore.signal()
        return
      }
      print(String(data: data, encoding: .utf8)!)
      semaphore.signal()
    }

    task.resume()
    semaphore.wait()
}
