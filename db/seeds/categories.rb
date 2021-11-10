module CategorySeeds
  def categories
    {
      home: nil,
      kitchen: nil,
      clothes: nil,
      clothes_accessories: nil,
      computer_accessories: nil,
      bench: :home,
      chair: :home,
      bottle: :kitchen,
      shirt: :clothes,
      shoes: :clothes,
      pants: :clothes,
      car: nil,
      coat: :clothes,
      hat: :clothes,
      wallet: :clothes_accessories,
      gloves: :clothes_accessories,
      clock: :home,
      keyboard: :computer_accessories,
      watch: :clothes_accessories,
      computer: nil,
      plate: :kitchen,
      lamp: :home,
      table: :home,
      bag: :clothes_accessories,
      knife: :kitchen
    }
  end
end
