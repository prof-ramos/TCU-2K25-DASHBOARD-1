
import React, { useEffect, useState } from 'react';

interface CountdownProps {
  dataProva: string;
}

const Countdown: React.FC<CountdownProps> = ({ dataProva }) => {
  const [timeLeft, setTimeLeft] = useState({
    totalDays: 0,
    months: 0,
    days: 0
  });

  useEffect(() => {
    const calculateTimeLeft = () => {
      const difference = +new Date(dataProva) - +new Date();
      let timeLeft = { totalDays: 0, months: 0, days: 0 };

      if (difference > 0) {
        const totalDays = Math.floor(difference / (1000 * 60 * 60 * 24));
        timeLeft = {
          totalDays: totalDays,
          months: Math.floor(totalDays / 30), // Aproximação de 30 dias por mês
          days: totalDays % 30
        };
      }
      return timeLeft;
    };

    const timer = setInterval(() => {
      setTimeLeft(calculateTimeLeft());
    }, 1000);

    return () => clearInterval(timer);
  }, [dataProva]);

  return (
    <div className="flex flex-col items-center gap-4">
      <div className="flex gap-4 justify-center">
        <FlipDigit value={timeLeft.months} label="meses" />
        <FlipDigit value={timeLeft.days} label="dias" />
      </div>
      <div className="flex justify-center">
        <FlipDigit value={timeLeft.totalDays} label="dias totais" />
      </div>
    </div>
  );
};

const FlipDigit: React.FC<{ value: number; label: string }> = ({ value, label }) => {
  const isTotalDays = label === "dias totais";
  const digits = String(value).padStart(isTotalDays ? 3 : 2, '0').split('');

  return (
    <div className="flex flex-col items-center">
      <div className={`flex gap-1 ${isTotalDays ? 'mb-3' : 'mb-2'}`}>
        {digits.map((digit, index) => (
          <FlipCard key={`${label}-${index}`} digit={digit} />
        ))}
      </div>
      <span className="text-xs text-muted-foreground uppercase tracking-wider">{label}</span>
    </div>
  );
};

const FlipCard: React.FC<{ digit: string }> = ({ digit }) => {
  const [isFlipping, setIsFlipping] = useState(false);
  const [prevDigit, setPrevDigit] = useState(digit);

  useEffect(() => {
    if (prevDigit !== digit) {
      setIsFlipping(true);
      const timer = setTimeout(() => {
        setIsFlipping(false);
        setPrevDigit(digit);
      }, 600); // Duração da animação
      return () => clearTimeout(timer);
    }
  }, [digit, prevDigit]);

  return (
    <div className="relative w-10 h-14 perspective-1000">
      <div className={`relative w-full h-full preserve-3d transition-transform duration-600 ease-in-out ${isFlipping ? 'animate-flip' : ''}`}>
        {/* Frente do cartão */}
        <div className="absolute inset-0 w-full h-full backface-hidden rounded-md bg-gradient-to-b from-background to-muted border border-border shadow-md">
          <div className="flex items-center justify-center h-full">
            <span className="text-2xl font-bold text-primary">{digit}</span>
          </div>
        </div>

        {/* Verso do cartão (dígito anterior durante flip) */}
        <div className="absolute inset-0 w-full h-full backface-hidden rounded-md bg-gradient-to-b from-muted to-background border border-border shadow-md rotate-y-180">
          <div className="flex items-center justify-center h-full">
            <span className="text-2xl font-bold text-primary opacity-50">{prevDigit}</span>
          </div>
        </div>

        {/* Topo curvo para dar profundidade */}
        <div className="absolute -top-1 left-0 right-0 h-1.5 bg-gradient-to-b from-background/20 to-transparent rounded-t-md"></div>

        {/* Sombra inferior */}
        <div className="absolute -bottom-1.5 left-1 right-1 h-1.5 bg-black/8 rounded-b-md blur-sm"></div>
      </div>
    </div>
  );
};

export default Countdown;
