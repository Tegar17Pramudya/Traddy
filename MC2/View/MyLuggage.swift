import SwiftUI

struct MyLuggage: View {
    @AppStorage("items2") var itemsData2: Data = Data()
    @State private var isShowingAddItemView2 = false
    @State private var newItemName2 = ""
    @State private var newItemColor2 = Color.gray
    @State private var newItemImage2: UIImage? = nil
    @Binding var itemsCount2: Int
    @State private var items2: [Item2] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment: .leading) {
                    Image("MyLuggageCoverPage")
                        .resizable()
                        .frame(height: 175)
                        .frame(maxWidth: .infinity)
                    HStack {
                        Image(systemName: "bag.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 22)
                            .foregroundColor(Color("Text"))
                        Text("What’s are My Luggage?")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Text"))
                    }.padding([.top, .leading], 20)
                    Text("Small Bag")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding([.top, .leading], 20)
                    ScrollView (.horizontal) {
                        HStack (spacing: 0) {
                            ForEach(items2, id: \.id) { item2 in
                                if item2.category == "small" {
                                    RectangleView2(item2: item2, items2: $items2)
                                }
                            }
                        }.padding(.leading, 10)
                    }
                    .frame(height: 200)
                    Text("Large Bag")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding([.top, .leading], 20)
                    ScrollView (.horizontal){
                        HStack(spacing: -10) {
                            ForEach(items2, id: \.id) { item2 in
                                if item2.category == "large" {
                                    RectangleView2(item2: item2, items2: $items2)
                                }
                            }
                            .padding(.leading, 10)
                        }
                    }
                    //                    .frame(height: 200)
                    Spacer()
                }
                .onAppear {
                    loadItems2()
                    updateItemCount2()
                }
                .onDisappear {
                    saveItems2()
                }
                PlusButton(action: {
                    isShowingAddItemView2 = true
                })
                .sheet(isPresented: $isShowingAddItemView2) {
                    AddItemView2(
                        isShowing2: $isShowingAddItemView2,
                        itemName2: $newItemName2,
                        itemColor2: $newItemColor2,
                        itemImage2: $newItemImage2,
                        items2: $items2,
                        itemsCount2: $itemsCount2,
                        completion: { itemName2 in
                            newItemName2 = itemName2
                            updateItemCount2()
                        }
                    )
                }
                
            }
            .ignoresSafeArea()
            .background(.white)
        }
    }
    
    func saveItems2() {
        do {
            let encodedData = try JSONEncoder().encode(items2)
            itemsData2 = encodedData
            updateItemCount2() // Memperbarui itemsCount setiap kali item disimpan
        } catch {
            print("Error saving items: \(error.localizedDescription)")
        }
    }
    
    func loadItems2() {
        do {
            let decodedItems = try JSONDecoder().decode([Item2].self, from: itemsData2)
            items2 = decodedItems
            updateItemCount2() // Memperbarui itemsCount setiap kali item dimuat
        } catch {
            print("Error loading items: \(error.localizedDescription)")
        }
    }
    
    func updateItemCount2() {
        itemsCount2 = items2.count
    }
}

struct RectangleView2: View {
    var item2: Item2
    @Binding var items2: [Item2]
    
    var body: some View {
        ZStack (alignment: .center){
            if item2.image != nil {
                Image(uiImage: item2.image!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: 150, maxHeight: 150)
                    .overlay(RoundedRectangle(cornerRadius: 15) .stroke(Color.gray, lineWidth: 5))
                    .background(Color("Text"))
                    .cornerRadius(15)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 150)
                    .foregroundColor(item2.color)
            }
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        removeItem2(item2)
                    }) {
                        ZStack{
                            Circle()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                                .frame(width: 25, height: 25)
                                .shadow(radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(5)
                }
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 150, height: 42)
                        .foregroundColor(Color("Button"))
                    Text(item2.name)
                        .font(.body)
                        .frame(width: 130, height: 32)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: 175, height: 175)
        .cornerRadius(15)
        .shadow(radius: 4, x:0 ,y: 2)
    }
    
    func removeItem2(_ item2: Item2) {
        items2.removeAll { $0.id == item2.id }
    }
}

struct AddItemView2: View {
    @Binding var isShowing2: Bool
    @Binding var itemName2: String
    @Binding var itemColor2: Color
    @Binding var itemImage2: UIImage?
    @Binding var items2: [Item2]
    @Binding var itemsCount2: Int
    
    //reset nama item
    var completion: (String) -> Void
    @State private var itemNameInput2: String = "Bag Name"
    
    @State private var showImagePicker2 = false
    @State private var sourceType2: UIImagePickerController.SourceType = .photoLibrary
    @State private var showImageSourceActionSheet2 = false
    
    @State private var selectedCategory = "small"
    var categories = ["small", "large"]
    
    @State var toggleIsOn: Bool = true
    @State var category = "Select Category"
    
    
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack (alignment: .leading, spacing: 20) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 15)
                            .frame(width: 330, height: 230)
                            .foregroundColor(itemColor2)
                        if toggleIsOn == true {
                            Image(systemName: "photo.fill.on.rectangle.fill")
                                .resizable()
                                .foregroundColor(.white)
                                .scaledToFit()
                                .frame(width: 80)
                            if isPhotoSelected2 {
                                if let image = itemImage2 {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 330, height: 230)
                                        .overlay(RoundedRectangle(cornerRadius: 15) .stroke(Color.gray, lineWidth: 5))
                                        .background(Color("Text"))
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    Text("Item Name")
                        .foregroundColor(.black)
                        .padding(.bottom, -10)
                    TextField("Bag Name", text: $itemNameInput2)
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(width: 330, height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 10) .stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(10)
                    
                    Toggle(isOn: $toggleIsOn,
                           label: {
                        Text("Use Picture")
                            .foregroundColor(.black)
                    }).toggleStyle(SwitchToggleStyle(tint: .green))
                        .frame(width: 330)
                    if toggleIsOn == false{
                        ColorPicker("Pick a Color", selection:$itemColor2)
                            .frame(width: 330)
                            .foregroundColor(.black)
                    }else{
                        Button(action: {
                            showImageSourceActionSheet2 = true
                            toggleIsOn = true
                        },label :{
                            HStack{
                                Image(systemName: "photo.fill.on.rectangle.fill")
                                Text("Select Picture")
                                    .foregroundColor(.black)
                            }
                        })
                    }
                    
                    //                    Picker("Choose Option", selection: Binding<SelectionOption2>(
                    //                        get: { return isPhotoSelected2 ? .photo : .color },
                    //                        set: { newValue in
                    //                            if newValue == .photo {
                    //                                showImageSourceActionSheet2 = true
                    //                            } else {
                    //                                itemImage2 = nil
                    //                            }
                    //                        }
                    //                    )) {
                    //                        Text("Choose Photo").tag(SelectionOption2.photo)
                    //                        Text("Choose Color").tag(SelectionOption2.color)
                    //                    }
                    //                    .pickerStyle(SegmentedPickerStyle())
                    //                    .padding()
                    //
                    //                    if !isPhotoSelected2 {
                    //                        ColorPicker("Item Color", selection: $itemColor2)
                    //                            .padding()
                    //                    }
                    
                    if isPhotoSelected2 {
                        if itemImage2 == nil {
                            Button(action: {
                                showImageSourceActionSheet2 = true
                            }) {
                                Text("Add Picture")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                    
                    Text("Category")
                        .foregroundColor(.black)
                    Menu{
                        Button (action:  {
                            category = "Small Bag"
                            selectedCategory = "small"
                        }, label:{
                            Text("Small Bag")
                        })
                        Button(action: {
                            category = "Large Bag"
                            selectedCategory = "large"
                            
                        }, label:{
                            Text("Large Bag")
                        })
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(Color("Field"))
                                .frame(width: 330, height: 32)
                            HStack {
                                Text("\(category)")
                                    .foregroundColor(Color(.black))
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color(.black))
                            }                                .padding(.horizontal, 10)
                            
                                .frame(width: 330)
                        }
                        .padding(.top, -10)
                    }
                    
                    //Memilih kategori ukuran barang
                    //                    Picker("Item Category", selection: $selectedCategory) {
                    //                        ForEach(categories, id: \.self) { category in
                    //                            Text(category)
                    //                                .tag(category)
                    //                        }
                    //                    }
                    //                    .pickerStyle(SegmentedPickerStyle())
                    //                    .padding()
                    Spacer()
                    RoundedButton(title: "Add Item", action: {
                        let newItem2: Item2
                        if isPhotoSelected2 {
                            newItem2 = Item2(id: UUID(), name: itemName2, color: .clear, image: itemImage2?.fixOrientation(), category: selectedCategory)
                        } else {
                            newItem2 = Item2(id: UUID(), name: itemName2, color: itemColor2, image: nil, category: selectedCategory)
                        }
                        items2.append(newItem2)
                        completion(itemNameInput2)
                        itemName2 = "" // Reset itemName to empty string
                        isShowing2 = false
                        itemImage2 = nil // Reset itemImage to nil
                    })
                    //                            .frame(width: 330)
                    //                    })
                    //                    .offset(x:0, y:0)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.white))
                .navigationTitle(itemNameInput2)
                .navigationBarTitleDisplayMode(.inline)
                .actionSheet(isPresented: $showImageSourceActionSheet2) {
                    ActionSheet(
                        title: Text("Choose Photo Source"),
                        buttons: [
                            .default(Text("Camera"), action: {
                                showImagePicker2 = true
                                sourceType2 = .camera
                            }),
                            .default(Text("Photo Library"), action: {
                                showImagePicker2 = true
                                sourceType2 = .photoLibrary
                            }),
                            .cancel()
                        ]
                    )
                }
                .sheet(isPresented: $showImagePicker2) {
                    ImagePicker(image: $itemImage2, sourceType: $sourceType2)
                }
                //                .navigationBarTitle(itemName2)
                .navigationBarItems(trailing: Button(action: {
                    isShowing2 = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                })
            }
        }
    }
    
    var isPhotoSelected2: Bool {
        return itemImage2 != nil
    }
    
    enum SelectionOption2 {
        case photo, color
    }
}

//fix rotate images
//extension UIImage {
//    func fixOrientation() -> UIImage {
//        if imageOrientation == .up {
//            return self
//        }
//
//        UIGraphicsBeginImageContextWithOptions(size, false, scale)
//        draw(in: CGRect(origin: .zero, size: size))
//        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return normalizedImage ?? self
//    }
//}

struct Item2: Identifiable, Codable {
    var id: UUID
    var name: String
    var color: Color
    var imageData: Data?
    var category: String
    
    // Computed property for converting the imageData to UIImage
    var image: UIImage? {
        if let imageData = imageData {
            return UIImage(data: imageData)
        }
        return nil
    }
    
    // Custom initializer for creating an item with an image
    init(id: UUID = UUID(), name: String, color: Color, image: UIImage?, category: String) {
        self.id = id
        self.name = name
        self.color = color
        self.imageData = image?.pngData()
        self.category = category
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, color, imageData, category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        imageData = try container.decode(Data?.self, forKey: .imageData)
        if let colorData = try container.decode(Data?.self, forKey: .color),
           let unarchivedColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData) {
            color = Color(unarchivedColor)
        } else {
            color = Color.gray
        }
        category = try container.decode(String.self, forKey: .category) // Decode and initialize the category property
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(imageData, forKey: .imageData)
        if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false) {
            try container.encode(colorData, forKey: .color)
        }
        try container.encode(category, forKey: .category) // Encode the category property
    }
    
}

struct MyLuggage_Previews: PreviewProvider {
    static var previews: some View {
        MyLuggage(itemsCount2: .constant(0)) // Menggunakan nilai default 0 untuk itemsCount
    }
}


