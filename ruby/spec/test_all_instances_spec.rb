require_relative 'spec_models/all_instances/Point.rb'

describe 'test_all_instances' do
  before do
    TADB::DB.clear_all
  end

  it 'crea tres puntos, guarda dos y trae dos' do
    p1 = Point.new
    p1.x = 2
    p1.y = 5
    p1.save!
    p2 = Point.new
    p2.x = 1
    p2.y = 3
    p2.save!

    # Si no salvamos p3 entonces no va a aparecer en la lista
    p3 = Point.new
    p3.x = 9
    p3.y = 7

    instances = Point.all_instances!

    expect(instances.length).to be 2
    expect(instances.any? { |instance| instance.x == 1 && instance.y == 3 }).to be true
    expect(instances.any? { |instance| instance.x == 2 && instance.y == 5 }).to be true

    p4 = instances.first
    p4.add(p2)
    p4.save!

    instances = Point.all_instances!

    expect(instances.length).to be 2
    expect(instances.any? { |instance| instance.x == 1 && instance.y == 3 }).to be true
    expect(instances.any? { |instance| instance.x == 3 && instance.y == 8 }).to be true

    p2.forget!

    instances = Point.all_instances!

    expect(instances.length).to be 1
    expect(instances.any? { |instance| instance.x == 3 && instance.y == 8 }).to be true
  end
end