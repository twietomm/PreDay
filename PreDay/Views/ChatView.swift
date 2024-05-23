//
//  ChatView.swift
//  PreDay
//
//  Created by Tom Herrmann on 16.05.24.
//
import SwiftUI
//import OpenAISwift
import GoogleGenerativeAI

struct ChatView: View {
    @ObservedObject var viewModel = ChatViewViewModel()
    //var longSttring = ChatLongString();
    let model = GenerativeModel(name: "gemini-pro", apiKey: APIKey.default)
    @State var text = ""
    @State var models = [String]()
    @State var aiResponse = ""
    @State var textToAI = ""
    @State var dateOfAppointment = TimeInterval()
    @State var titelOfAppointment = ""
    @StateObject var viewItemModel = NewItemViewViewModel()
    @State var dateString = ""
    @State var titleString = ""
     
    //
    
    var body: some View {

        NavigationView{
            VStack(alignment: .leading) {
                ScrollView{
                    ForEach(models, id: \.self){ string in
                        Text(string)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .padding(.bottom, 5)
                    }
                }
                .background(Color.gray.opacity(0.1))
                Spacer()
                
                HStack{
                    TextField("Type here...", text: $text)
                    Button("Chat\n"){
                        sendMessage()
                    }
                    Button("Meet"){
                        sendMessageMeeting()
                    }
                }
            }
            .navigationTitle("Chat with AI")
            .padding()
            .onAppear{
                self.models.append(chatPrep(choose: 1))
                //sendSecretMessage(secretMessage: chatPrep(choose: 2))
            }
        }
        
        //self.models.append(firstResponseOfAI)
        //
    }
    func sendMessage(){
        aiResponse = ""
        Task{
            do{
                guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                    return
                }
                self.models.append("Me: " + text)
                let response = try await model.generateContent(text)
                
                guard let text1 = response.text else{
                    text = "Error"
                    return
                }
                print(text1)
                
                
                self.models.append("AI: " + text1)
                
                self.text = ""
                
            }catch{
                aiResponse = "Something went wrong \(error.localizedDescription)"
            }
        }
    }
    func sendMessageMeeting(){
        aiResponse = ""
        Task{
            do{
                guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
                    return
                }
                self.models.append("Me: " + text)
                let response = try await model.generateContent(chatPrep(choose:2) + text)
                
                guard let text1 = response.text else{
                    text = "Error"
                    return
                }
                print(text1)
                if (containsAllElements(in: text1)){
                    dateString = extractFormattedDate(from: text1)!
                    titleString = extractTitle(from: text1)!
                    viewItemModel.setDueDate(from: dateString)
                    viewItemModel.setTitle(titleString: titleString)
                    print(dateString)
                    print(titleString)
                    viewItemModel.save1()
                    self.models.append("AI: " + extractConclusion(from: text1))
                }else{
                    self.models.append("AI: " + text1)
                }
                self.text = ""
                
            }catch{
                aiResponse = "Something went wrong \(error.localizedDescription)"
            }
        }
    }
    
    func sendSecretMessage(secretMessage: String){
        aiResponse = ""
        Task{
            do{
                
                let response = try await model.generateContent(secretMessage)
                self.models.append("Me: " + secretMessage)// comment out
                guard let text1 = response.text else{
                    text = "Error"
                    return
                }
                self.models.append("AI: " + text1) // comment out
                self.textToAI = ""
                
            }catch{
                aiResponse = "Something went wrong \(error.localizedDescription)"
            }
        }
    }

    func extractFormattedDate(from text: String) -> String? {
        // Define the regex pattern for the date
        let pattern = "DATEBEGIN \\d{4}:\\d{2}:\\d{2}:\\d{2}:\\d{2} DATEEND"
        
        do {
            // Create a regular expression object
            let regex = try NSRegularExpression(pattern: pattern)
            
            // Search for the first match in the input text
            if let match = regex.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
                // Extract the matching string
                if let range = Range(match.range, in: text) {
                    let dateString = String(text[range])
                    
                    // Extract the actual date part from the matched string
                    let datePattern = "\\d{4}:\\d{2}:\\d{2}:\\d{2}:\\d{2}"
                    if let dateRange = dateString.range(of: datePattern, options: .regularExpression) {
                        let datePart = String(dateString[dateRange])
                        
                        // Convert the date part to the desired format
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy:MM:dd:HH:mm"
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        
                        if let date = dateFormatter.date(from: datePart) {
                            // Create a new formatter for the desired output format
                            let outputFormatter = DateFormatter()
                            outputFormatter.dateFormat = "dd.MM.yyyy HH:mm"
                            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            
                            let formattedDate = outputFormatter.string(from: date)
                            return formattedDate
                        }
                    }
                }
            }
        } catch {
            print("Invalid regex pattern: \(error.localizedDescription)")
        }
        
        return nil
    }

    func extractTitle(from input: String) -> String? {
        // Regex pattern to find the title in the format "TITELSTART _Titel_ TITELEND"
        let pattern = "TITELSTART (.+?) TITELEND"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsrange = NSRange(input.startIndex..<input.endIndex, in: input)
            
            if let match = regex.firstMatch(in: input, options: [], range: nsrange) {
                if let titleRange = Range(match.range(at: 1), in: input) {
                    let title = String(input[titleRange])
                    return title
                }
            }
        } catch {
            print("Invalid regex pattern")
        }
        
        return nil
    }


    func extractConclusion(from input: String) -> String {
        // Regex pattern to find the conclusion in the format "CONCLUSIONSTART _Conclusion of appointment_ CONCLUSIONEND"
        let pattern = "CONCLUSIONSTART (.+?) CONCLUSIONEND"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let nsrange = NSRange(input.startIndex..<input.endIndex, in: input)
            
            if let match = regex.firstMatch(in: input, options: [], range: nsrange) {
                if let conclusionRange = Range(match.range(at: 1), in: input) {
                    let conclusion = String(input[conclusionRange])
                    return conclusion
                }
            }
        } catch {
            print("Invalid regex pattern")
        }
        
        return "error"
    }
    func containsAllElements(in input: String) -> Bool {
        // Regex patterns for the date, title, and conclusion
        let datePattern = "DATEBEGIN (\\d{4}):(\\d{2}):(\\d{2}):(\\d{2}):(\\d{2}) DATEEND"
        let titlePattern = "TITELSTART (.+?) TITELEND"
        let conclusionPattern = "CONCLUSIONSTART (.+?) CONCLUSIONEND"
        
        do {
            let dateRegex = try NSRegularExpression(pattern: datePattern, options: [])
            let titleRegex = try NSRegularExpression(pattern: titlePattern, options: [])
            let conclusionRegex = try NSRegularExpression(pattern: conclusionPattern, options: [])
            
            let nsrange = NSRange(input.startIndex..<input.endIndex, in: input)
            
            let dateFound = dateRegex.firstMatch(in: input, options: [], range: nsrange) != nil
            let titleFound = titleRegex.firstMatch(in: input, options: [], range: nsrange) != nil
            let conclusionFound = conclusionRegex.firstMatch(in: input, options: [], range: nsrange) != nil
            
            return dateFound && titleFound && conclusionFound
        } catch {
            print("Invalid regex pattern")
            return false
        }
    }
    func chatPrep(choose: Int) -> String{    //Gemini wird auf personal Assistant eingestellt.
        var firstResponseOfAI = "AI: How should we prepare your day?"
        
        var trainPersonalAssist = "You are my personal assistant for appointments. This means that I will give you a message that you need to handle like a secretary. You should extract the date, time, and a suitable title from the messages. The first line should be the date and time for the appointment. The second line should always be the title of the appointment. From the third line onwards, you summarize the appointment. Please respond exactly in this format:\n  \n TITELSTART Titel TITELEND \n\n DATEBEGIN yyyy:mm:dd:hh:mm DATEEND \n \n CONCLUSIONSTART Conlusion of appointment CONCLUSIONEND \n \nThis is the message: \n \n"


        switch choose{
        case 1: return firstResponseOfAI
        case 2: return trainPersonalAssist
        default: return "none"
        }
 
        
    }
    func justAISaying(textOfAI: String){
        self.models.append("AI: " + textOfAI)
    }

    struct ChatView_Previews:  PreviewProvider{
        static var previews: some View {
            ChatView()
        }
    }
    
    
}
