require 'spec_helper'

describe Gregex do
  plain_vowels = %w(α ε ι η ο υ ω)
  vowels_with_acute = %w(ά έ ή ί ό ύ ώ)
  vowels_with_grave = %w(ὰ ὲ ὴ ὶ ὸ ὺ ὼ)
  vowels_with_circumflex = %w(ᾶ ῆ ῖ ῦ ῶ)
  vowels = %w(α ε ι η ο υ ω
              ά έ ή ί ό ύ ώ
              ὰ ὲ ὴ ὶ ὸ ὺ ὼ
              ᾶ ῆ ῖ ῦ ῶ
              ἂ ἒ ἲ ἢ ὂ ὒ ὢ
              ᾲ ᾳ ᾴ ᾷ ῂ ῃ ῄ ῇ ῲ ῳ ῴ ῷ
              ἀ ἐ ἠ ἰ ὀ ὐ ὠ
              ἄ ἔ ἴ ἤ ὄ ὔ ὤ
              ἆ ἶ ἦ ὖ ὦ
              ἁ ἑ ἡ ἱ ὁ ὑ ὡ
              ἇ ἷ ἧ ὗ ὧ
              ἃ ἣ ἓ ἳ ὃ ὓ ὣ
              ἅ ἥ ἕ ἵ ὅ ὕ ὥ
              ᾀ ᾁ ᾂ ᾃ ᾄ ᾅ ᾆ ᾇ ᾐ ᾑ ᾒ ᾓ ᾔ ᾕ ᾖ ᾗ ᾠ ᾡ ᾢ ᾣ ᾤ ᾥ ᾦ ᾧ)

  consonants = %w(β γ δ ζ θ κ λ μ ν ξ π ρ ῥ ῤ σ ς τ φ χ ψ)
  all_downcase_letters = vowels + consonants

  all_capital_letters = %w(
        Α Ε Η Ι Ο Υ Ω
        Ἀ Ἁ Ἂ Ἃ Ἄ Ἅ Ἆ Ἇ ᾈ ᾉ ᾊ ᾋ ᾌ ᾍ ᾎ ᾏ
        Ἐ Ἑ Ἒ Ἓ Ἔ Ἕ
        Ἠ Ἡ Ἢ Ἣ Ἤ Ἥ Ἦ Ἧ ᾘ ᾙ ᾚ ᾛ ᾜ ᾝ ᾞ ᾟ
        Ἰ Ἱ Ἲ Ἳ Ἴ Ἵ Ἶ Ἷ
        Ὀ Ὁ Ὂ Ὃ Ὄ Ὅ
        Ὑ Ὓ Ὕ Ὗ
        Ὠ Ὡ Ὢ Ὣ Ὤ Ὥ Ὦ Ὧ ᾨ ᾩ ᾪ ᾫ ᾬ ᾭ ᾮ ᾯ)

  it 'should have a version number' do
    Gregex::VERSION.should_not be_nil
  end

  describe ".regex" do
    context "with \/\\w\/" do
      regex = Gregex.new.regex(/\w/)
      all_downcase_letters.each do |letter|
        it "matches #{letter}" do
          expect(regex).to match(letter)
        end
      end

      all_capital_letters.each do |letter|
        it "matches #{letter}" do
          expect(regex).to match(letter)
        end
      end
    end

    context "with \/\\w+\/" do
      describe "matches one or more greek chars" do
        it "like κλμ" do
          regex = Gregex.new.regex(/\w+/)
          expect(regex).to match("κλμ")
        end

        it "like κ" do
          regex = Gregex.new.regex(/\w+/)
          expect(regex).to match("κ")
        end
      end
    end

    context "with \/\\w{2}\/" do
      describe "matches exact 2 greek chars" do
        it "like κλμ" do
          regex = Gregex.new.regex(/\w{2}/)
          expect(regex).to match("κλμ")
          expect(regex).not_to match("κ λ μ")
        end
      end
    end

    context "with \/\\S\/" do
      describe "matches any non white-space-char" do
        it "like κλμ" do
          regex = Gregex.new.regex(/\S/)
          expect(regex).to match("κλμ")
        end

        it "like ." do
          regex = Gregex.new.regex(/\S/)
          expect(regex).to match(".")
        end
      end
    end

    context "with \/[]\/" do
      describe "matches group of chars" do
        describe "like [α-ω]" do
          regex = Gregex.new.regex(/[α-ω]/)
          plain_vowels.each do |vow|
            it "matches #{vow}" do
              expect(regex).to match(vow)
            end
          end
        end

        describe "like [^α-ω]" do
          regex = Gregex.new.regex(/[^α-ω]/)
          consonants.each do |con|
            it "matches #{con}" do
              expect(regex).to match(con)
            end
          end
        end

        describe "like [β-ψ]" do
          regex = Gregex.new.regex(/[β-ψ]/)
          consonants.each do |con|
            it "matches #{con}" do
              expect(regex).to match(con)
            end
          end
        end

        describe "like [ά-ώ]" do
          regex = Gregex.new.regex(/[ά-ώ]/)
          vowels_with_acute.each do |vow|
            it "matches #{vow}" do
              expect(regex).to match(vow)
            end
          end
        end

        describe "like [ὰ-ὼ]" do
          regex = Gregex.new.regex(/[ὰ-ὼ]/)
          vowels_with_grave.each do |vow|
            it "matches #{vow}" do
              expect(regex).to match(vow)
            end
          end
        end

        describe "like [ᾶ-ῶ]" do
          regex = Gregex.new.regex(/[ᾶ-ῶ]/)
          vowels_with_circumflex.each do |vow|
            it "matches #{vow}" do
              expect(regex).to match(vow)
            end
          end
        end
      end
    end

    context "with complex expressions" do
      describe "like \/\\w[α-ω]\/" do
        it "matches βω" do
          regex = Gregex.new.regex(/\w[α-ω]/)
          expect(regex).to match("βω")
        end
      end
    end

    context "with options" do
      describe "with i" do
        it "is case insensitive" do
          regex = Gregex.new.regex(/α/, "i")
          expect(regex).to match ("α")
          expect(regex).to match ("Α")
        end

        it "works with [...]" do
          regex = Gregex.new.regex(/[α-ω]/, "i")
          expect(regex).to match ("α")
          expect(regex).to match ("Α")
        end
      end

      describe "with c" do
        context "ignores all diacritics" do
          it "with \/[α-ω]\/" do
            regex = Gregex.new.regex(/[α-ω]/, "c")
            expect(regex).to match ("ά")
          end

          context "works with all vowels and diacritics" do
            it "with α" do
              regex = Gregex.new.regex(/α/, "c")
              expect(regex).to match ("ά")
              expect(regex).to match ("ὰ")
              expect(regex).to match ("ἀ")
              expect(regex).to match ("ἁ")
              expect(regex).to match ("ᾶ")
              expect(regex).to match ("ἄ")
              expect(regex).to match ("ἂ")
              expect(regex).to match ("ἃ")
              expect(regex).to match ("ἅ")
              expect(regex).to match ("ἆ")
              expect(regex).to match ("ᾳ")
              # and some more...
            end

            it "with ε" do
              regex = Gregex.new.regex(/ε/, "c")
              expect(regex).to match ("ἒ")
            end

            it "with η" do
              regex = Gregex.new.regex(/η/, "c")
              expect(regex).to match ("ῇ")
            end

            it "with ι" do
              regex = Gregex.new.regex(/ι/, "c")
              expect(regex).to match ("ί")
            end

            it "with ο" do
              regex = Gregex.new.regex(/ο/, "c")
              expect(regex).to match ("ὸ")
            end

            it "with υ" do
              regex = Gregex.new.regex(/υ/, "c")
              expect(regex).to match ("ὖ")
            end

            it "with ω" do
              regex = Gregex.new.regex(/ω/, "c")
              expect(regex).to match ("ᾦ")
            end

          end
        end
      end
    end

    context "with real world examples" do
      it "matches various variants of οὐδε" do
        regex = Gregex.new.regex(/ουδε/, "c")
        expect(regex).to match ("οὐδὲ")
      end
    end
  end
end
